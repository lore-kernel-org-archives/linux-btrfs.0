From: Sean Bartell <wingedtachikoma@gmail.com>
Subject: Re: [PATCH 2/4] btrfs-convert: Add extent iteration functions.
Date: Mon, 22 Mar 2010 00:55:26 -0400
Message-ID: <20100322045526.GA21666@flcl.lan>
References: <20100320042649.GA17106@flcl.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100320042649.GA17106@flcl.lan>
List-ID: <linux-btrfs.vger.kernel.org>

Whoops, there's a major memory leak. Please apply this patch to the
patch :).

diff --git a/convert.c b/convert.c
index dfd2976..7bb4ed0 100644
--- a/convert.c
+++ b/convert.c
@@ -471,21 +471,24 @@ int finish_file_extents(struct extent_iterate_data *priv)
 				return ret;
 		}
 		*priv->inode_nbytes += priv->size;
-		return btrfs_insert_inline_extent(priv->trans, priv->root,
-						  priv->objectid,
-						  priv->file_off, priv->data,
-						  priv->size);
-	}
-
-	ret = commit_file_extents(priv);
-	if (ret)
-		return ret;
-
-	if (priv->total_size > priv->last_file_off) {
-		ret = commit_disk_extent(priv, priv->last_file_off, 0,
-					priv->total_size - priv->last_file_off);
+		ret = btrfs_insert_inline_extent(priv->trans, priv->root,
+						 priv->objectid,
+						 priv->file_off, priv->data,
+						 priv->size);
 		if (ret)
 			return ret;
+	} else {
+		ret = commit_file_extents(priv);
+		if (ret)
+			return ret;
+
+		if (priv->total_size > priv->last_file_off) {
+			ret = commit_disk_extent(priv, priv->last_file_off, 0,
+						 priv->total_size -
+						 priv->last_file_off);
+			if (ret)
+				return ret;
+		}
 	}
 	free(priv->data);
 	return 0;
