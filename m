From: Leonidas Spyropoulos <artafinde@gmail.com>
Subject: Fwd: TRIM support
Date: Sun, 3 Jul 2011 16:28:34 +0100
Message-ID: <CAAeznTpkVCa3npgHfAG84OgbiEo-Y30YPQQgoqtuH_gpuBjnLA@mail.gmail.com>
References: <CAAeznTr5FMOqyJA9JfP2H-h1rJjasfxUJAeNNnNKhiHCTV03mA@mail.gmail.com>
	<201107031420.45718.hka@qbs.com.pl>
	<CAAeznTpCXWz+dth4PiMneV23NiLyr8c+usiw07Gkn6=AvaVM9g@mail.gmail.com>
	<201107031654.03363.kario@wit.edu.pl>
	<CAAeznTqPdQ99Qv7jFFthsZPdHN7ZedPszEJKhpe18gBEvR8=JQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTqPdQ99Qv7jFFthsZPdHN7ZedPszEJKhpe18gBEvR8=JQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 3, 2011 at 3:54 PM, Hubert Kario <kario@wit.edu.pl> wrote:
> On Sunday 03 of July 2011 14:56:40 Leonidas Spyropoulos wrote:
>> On Sun, Jul 3, 2011 at 1:20 PM, Hubert Kario <hka@qbs.com.pl> wrote:
>> > On Sunday 03 of July 2011 00:40:46 Leonidas Spyropoulos wrote:
>> >> On Sat, Jul 2, 2011 at 11:39 PM, Leonidas Spyropoulos
>> >>
>> >> <artafinde@gmail.com> wrote:
>> >> > On Sat, Jul 2, 2011 at 8:45 PM, Calvin Walton
>> >> > <calvin.walton@kepstin.ca>
>> >
>> > wrote:
>> >> >> On Sat, 2011-07-02 at 19:08 +0100, Leonidas Spyropoulos wrote:
>> >> >>> Hello,
>> >> >>>
>> >> >>> I just installed an archlinux with btrfs root partition and w=
ould
>> >> >>> like to set the correct mount properties
>> >> >>> Following this:
>> >> >>> https://wiki.archlinux.org/index.php/Solid_State_Drives
>> >> >>> it says there that I should use the discard mount parameter t=
o
>> >> >>> enable TRIM.
>> >> >>>
>> >> >>> I would like to ask by using ssd mount parameter would TRIM b=
e
>> >> >>> enabled? The SSD is Intel 320 Series 120Gb
>> >> >>
>> >> >> No, the "ssd" mount parameter has nothing to do with TRIM.
>> >> >>
>> >> >> The "ssd" mount parameter adjusts a couple of tuning parameter=
s where
>> >> >> the default setting is designed to improve performance on spin=
ning
>> >> >> HDD, and instead tunes for the random-access ability of an SSD=
=2E
>> >> >>
>> >> >> The ssd option is automatically enabled if the kernel detects =
that
>> >> >> your drive is an SSD (you can check with 'cat /proc/mounts').
>> >> >>
>> >> >> The discard option is not currently automatically enabled; I t=
hink
>> >> >> there may have been some performance issues in certain cases w=
ith
>> >> >> drives that have slow trim implementations. But feel free to g=
ive it
>> >> >> a try.
>> >> >>
>> >> >> --
>> >> >> Calvin Walton <calvin.walton@kepstin.ca>
>> >>
>> >> On the same system when I try to compile the btrfs-tools I get an=
 error.
>> >> Since on the wiki you mention only the packages for Fedora and De=
bian,
>> >>
>> >> Which are the requirements for the btrfs tools?
>> >>
>> >> PS: AUR package is broken as well.
>> >
>> > the AUR package is OK, problem is that the sources don't compile w=
ith new
>> > gcc.
>> >
>> > Download Hugo's integration branch
>> > http://git.darksatanic.net/repo/btrfs-progs-unstable.git/
>> > integration-20110630
>>
>> I download the files:
>>
>> git clone =A0http://git.darksatanic.net/repo/btrfs-progs-unstable.gi=
t/
>> integration-20110630
>>
>> > and apply my patch to it:
>> > http://www.spinics.net/lists/linux-btrfs/msg10965.html
>>
>> Then I tried to apply the patch you mentioned:
>>
>> patch < rem.diff
>>
>> but it's failing:
>> The rem.diff is the file attached
>>
>> > --
>> > Hubert Kario
>> > QBS - Quality Business Software
>> > 02-656 Warszawa, ul. Ksawer=F3w 30/85
>> > tel. +48 (22) 646-61-51, 646-74-24
>> > www.qbs.com.pl
>>
>> Here is the error I am getting:
>> patching file mkfs.c
>> Hunk #1 FAILED at 1060.
>> Hunk #2 FAILED at 1070.
>> 2 out of 2 hunks FAILED -- saving rejects to file mkfs.c.rej
>> patching file volumes.c
>> Hunk #1 FAILED at 868.
>> Hunk #2 FAILED at 920.
>> 2 out of 2 hunks FAILED -- saving rejects to file volumes.c.rej
>>
>> I think the file I created is wrong.
>> What is the accepted format for the patch command?
>
> You may also want to try
> git checkout integration-20110626
> there were some problems with 20110630 AFAICR
>
> Hubert
>
Hey Hubert,

Thanks for the suggestions
I think I am using the wrong format for the patch.
Can you confirm that the patch file named rem.diff should be like the
one I attach on the email?

I get the same error when trying git apply on both integrations:
git apply ../rem.diff
error: patch failed: mkfs.c:1060
error: mkfs.c: patch does not apply
error: patch failed: volumes.c:888
error: volumes.c: patch does not apply

I finally got it to compile the integration-20110626 by manually
finding the four lines and deleting them.

Here is the git diff
---
diff --git a/mkfs.c b/mkfs.c
index 1b5ef06..d40b2e8 100644
--- a/mkfs.c
+++ b/mkfs.c
@@ -1060,7 +1060,6 @@ static int make_image(char *source_dir, struct
btrfs_root *root, int
=A0 =A0 =A0 =A0struct btrfs_trans_handle *trans;

=A0 =A0 =A0 =A0struct stat root_st;
- =A0 =A0 =A0 int root_len;

=A0 =A0 =A0 =A0struct directory_name_entry dir_head;

@@ -1070,8 +1069,6 @@ static int make_image(char *source_dir, struct
btrfs_root *root, int
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto fail;
=A0 =A0 =A0 =A0}

- =A0 =A0 =A0 root_len =3D strlen(source_dir);
-
=A0 =A0 =A0 =A0INIT_LIST_HEAD(&dir_head.list);

=A0 =A0 =A0 =A0trans =3D btrfs_start_transaction(root, 1);
diff --git a/volumes.c b/volumes.c
index 61af845..95c2e0d 100644
--- a/volumes.c
+++ b/volumes.c
@@ -868,7 +868,6 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handl=
e *trans,
=A0 =A0 =A0 =A0struct list_head *dev_list =3D &extent_root->fs_info->fs=
_devices->devices;
=A0 =A0 =A0 =A0struct list_head *cur;
=A0 =A0 =A0 =A0struct map_lookup *map;
- =A0 =A0 =A0 u64 physical;
=A0 =A0 =A0 =A0u64 calc_size =3D 8 * 1024 * 1024;
=A0 =A0 =A0 =A0int num_stripes =3D 1;
=A0 =A0 =A0 =A0int sub_stripes =3D 0;
@@ -920,7 +919,6 @@ int btrfs_alloc_data_chunk(struct btrfs_trans_handl=
e *trans,
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_set_stack_stripe_devid(stripe, dev=
ice->devid);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0btrfs_set_stack_stripe_offset(stripe, de=
v_offset);
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0memcpy(stripe->dev_uuid, device->uuid, B=
TRFS_UUID_SIZE);
- =A0 =A0 =A0 =A0 =A0 =A0 =A0 physical =3D dev_offset;
=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0index++;
=A0 =A0 =A0 =A0}

Thanks for the help

Leonidas

P.S.: I always forget to Reply to All Sorry for double email Hubert
--
Caution: breathing may be hazardous to your health.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
