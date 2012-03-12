From: Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 2/2] Btrfs: avoid possible use-after-free in clear_extent_bit()
Date: Mon, 12 Mar 2012 16:39:48 +0800
Message-ID: <4F5DB654.6020807@cn.fujitsu.com>
References: <4F5DB640.3010102@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F5DB640.3010102@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

clear_extent_bit()
{
    next_node =3D rb_next(&state->rb_node);
    ...
    clear_state_bit(state);  <-- this may free next_node
    if (next_node) {
        state =3D rb_entry(next_node);
        ...
    }
}

clear_state_bit() calls merge_state() which may free the next node
of the passing extent_state, so clear_extent_bit() may end up
referencing freed memory.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

=E7=BB=8F=E8=BF=87=E6=B5=8B=E8=AF=95=EF=BC=8C=E5=8F=91=E7=8E=B0clear_st=
ate_bit()=E4=BC=9A=E5=9C=A880%=E7=9A=84=E6=83=85=E5=86=B5=E4=B8=8B=E7=9B=
=B4=E6=8E=A5=E6=8A=8Astate free=E6=8E=89=E3=80=82=E6=89=80=E4=BB=A5=E4=B9=
=8B=E5=89=8D
=E7=9A=84=E6=AF=94=E8=BE=83=E7=AE=80=E5=8D=95=E7=9A=84patch=EF=BC=8C=E4=
=BC=9A=E5=9C=A880%=E7=9A=84=E6=83=85=E5=86=B5=E4=B8=8B=E9=87=8D=E6=96=B0=
goto=E5=9B=9E=E5=8E=BB=E6=90=9C=E7=B4=A2rbtree=EF=BC=8C=E4=BC=9A=E5=BE=88=
=E6=85=A2=E3=80=82=E6=89=80=E4=BB=A5=EF=BC=8C=E7=8E=B0=E5=9C=A8
=E6=94=B9=E6=88=90=E7=94=B1clear_state_bit()=E8=BF=94=E5=9B=9E=E4=B8=8B=
=E4=B8=80=E4=B8=AAstate=E3=80=82

---
 fs/btrfs/extent_io.c |   36 +++++++++++++++++++++---------------
 1 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index c968c95..20f2f5a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -392,6 +392,15 @@ static int split_state(struct extent_io_tree *tree=
, struct extent_state *orig,
 	return 0;
 }
=20
+static struct extent_state *next_state(struct extent_state *state)
+{
+	struct rb_node *next =3D rb_next(&state->rb_node);
+	if (next)
+		return rb_entry(next, struct extent_state, rb_node);
+	else
+		return NULL;
+}
+
 /*
  * utility function to clear some bits in an extent state struct.
  * it will optionally wake up any one waiting on this state (wake =3D=3D=
 1)
@@ -399,10 +408,11 @@ static int split_state(struct extent_io_tree *tre=
e, struct extent_state *orig,
  * If no bits are set on the state struct after clearing things, the
  * struct is freed and removed from the tree
  */
-static void clear_state_bit(struct extent_io_tree *tree,
-			    struct extent_state *state,
-			    int *bits, int wake)
+static struct extent_state *clear_state_bit(struct extent_io_tree *tre=
e,
+					    struct extent_state *state,
+					    int *bits, int wake)
 {
+	struct extent_state *next;
 	int bits_to_clear =3D *bits & ~EXTENT_CTLBITS;
=20
 	if ((bits_to_clear & EXTENT_DIRTY) && (state->state & EXTENT_DIRTY)) =
{
@@ -415,6 +425,7 @@ static void clear_state_bit(struct extent_io_tree *=
tree,
 	if (wake)
 		wake_up(&state->wq);
 	if (state->state =3D=3D 0) {
+		next =3D next_state(state);
 		if (state->tree) {
 			rb_erase(&state->rb_node, &tree->state);
 			state->tree =3D NULL;
@@ -424,7 +435,9 @@ static void clear_state_bit(struct extent_io_tree *=
tree,
 		}
 	} else {
 		merge_state(tree, state);
+		next =3D next_state(state);
 	}
+	return next;
 }
=20
 static struct extent_state *
@@ -456,7 +469,6 @@ int clear_extent_bit(struct extent_io_tree *tree, u=
64 start, u64 end,
 	struct extent_state *state;
 	struct extent_state *cached;
 	struct extent_state *prealloc =3D NULL;
-	struct rb_node *next_node;
 	struct rb_node *node;
 	u64 last_end;
 	int err;
@@ -508,14 +520,11 @@ hit_next:
 	WARN_ON(state->end < start);
 	last_end =3D state->end;
=20
-	if (state->end < end && !need_resched())
-		next_node =3D rb_next(&state->rb_node);
-	else
-		next_node =3D NULL;
-
 	/* the state doesn't have the wanted bits, go ahead */
-	if (!(state->state & bits))
+	if (!(state->state & bits)) {
+		state =3D next_state(state);
 		goto next;
+	}
=20
 	/*
 	 *     | ---- desired range ---- |
@@ -569,16 +578,13 @@ hit_next:
 		goto out;
 	}
=20
-	clear_state_bit(tree, state, &bits, wake);
+	state =3D clear_state_bit(tree, state, &bits, wake);
 next:
 	if (last_end =3D=3D (u64)-1)
 		goto out;
 	start =3D last_end + 1;
-	if (start <=3D end && next_node) {
-		state =3D rb_entry(next_node, struct extent_state,
-				 rb_node);
+	if (start <=3D end && state && !need_resched())
 		goto hit_next;
-	}
 	goto search_again;
=20
 out:
-- 1.7.3.1=20
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
