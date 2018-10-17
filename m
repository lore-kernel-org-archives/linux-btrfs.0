Return-Path: <SRS0=tjhn=M5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF11FECDE32
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A32DA21523
	for <linux-btrfs@archiver.kernel.org>; Wed, 17 Oct 2018 08:33:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bC8sse60"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A32DA21523
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbeJQQ2d (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 17 Oct 2018 12:28:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46380 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbeJQQ2d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 Oct 2018 12:28:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=7yeEEcTYioqDviaeJ8vzAEXCBQahhiUF4tValgwLko4=; b=bC8sse60fRTmmBtJTrvS+cDcB
        avlY+sn+TwQXkxg0B8aJhYHvrW+ec5EA4o5WTbURYOtalyO6H+LQRcclM6BTgfE+eUkvnm3MdoWMj
        /+7OzA3Zy1iVMrziuLqTkcHmojisVVEWfaec0thqdNcrG3eRFVXZ7tzaqcaGab41sXU/A6YJyVQ9m
        WXzeUjWRJ14Z/68cfVZoeKtUpDO1R1xwqfPEmy1ISwyMpE18XoE0SGZ3tSzHlkCG2BXCuY+BCVa4r
        B0lfciMxyF0Mh60sbH+OjWTgemHeIkDggSkFsU/QxQUSr8s/1iL6GsyNFkvacK1VHVsJX2mOG68Et
        dvt6Gya9w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gChH9-00087U-Mf; Wed, 17 Oct 2018 08:33:55 +0000
Date:   Wed, 17 Oct 2018 01:33:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     david@fromorbit.com, sandeen@redhat.com, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-mm@kvack.org, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 13/26] vfs: create generic_remap_file_range_touch to
 update inode metadata
Message-ID: <20181017083355.GE16896@infradead.org>
References: <153965939489.1256.7400115244528045860.stgit@magnolia>
 <153965996673.3607.133184523000924340.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <153965996673.3607.133184523000924340.stgit@magnolia>
User-Agent: Mutt/1.9.2 (2017-12-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 15, 2018 at 08:19:26PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a new VFS helper to handle inode metadata updates when remapping
> into a file.  If the operation can possibly alter the file contents, we
> must update the ctime and mtime and remove security privileges, just
> like we do for regular file writes.  Wire up ocfs2 to ensure consistent
> behavior.

Subject line doesn't match the actual function name..

> +/* Update inode timestamps and remove security privileges when remapping. */
> +static int generic_remap_file_range_target(struct file *file,
> +					   unsigned int remap_flags)
> +{
> +	int ret;
> +
> +	/* If can't alter the file contents, we're done. */
> +	if (remap_flags & REMAP_FILE_DEDUP)
> +		return 0;
> +
> +	/* Update the timestamps, since we can alter file contents. */
> +	if (!(file->f_mode & FMODE_NOCMTIME)) {
> +		ret = file_update_time(file);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	/*
> +	 * Clear the security bits if the process is not being run by root.
> +	 * This keeps people from modifying setuid and setgid binaries.
> +	 */
> +	return file_remove_privs(file);
> +}
> +
>  /*
>   * Check that the two inodes are eligible for cloning, the ranges make
>   * sense, and then flush all dirty data.  Caller must ensure that the
> @@ -1820,6 +1844,10 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
>  	if (ret)
>  		return ret;
>  
> +	ret = generic_remap_file_range_target(file_out, remap_flags);
> +	if (ret)
> +		return ret;
> +

Also I find the name still somewhat odd.  Why don't we side-step that
issue by moving the code directly into generic_remap_file_range_prep?

Something like this folded in:

diff --git a/fs/read_write.c b/fs/read_write.c
index 37a7d3fe35d8..6de813cf9e63 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1752,30 +1752,6 @@ static int generic_remap_check_len(struct inode *inode_in,
 	return (remap_flags & REMAP_FILE_DEDUP) ? -EBADE : -EINVAL;
 }
 
-/* Update inode timestamps and remove security privileges when remapping. */
-static int generic_remap_file_range_target(struct file *file,
-					   unsigned int remap_flags)
-{
-	int ret;
-
-	/* If can't alter the file contents, we're done. */
-	if (remap_flags & REMAP_FILE_DEDUP)
-		return 0;
-
-	/* Update the timestamps, since we can alter file contents. */
-	if (!(file->f_mode & FMODE_NOCMTIME)) {
-		ret = file_update_time(file);
-		if (ret)
-			return ret;
-	}
-
-	/*
-	 * Clear the security bits if the process is not being run by root.
-	 * This keeps people from modifying setuid and setgid binaries.
-	 */
-	return file_remove_privs(file);
-}
-
 /*
  * Read a page's worth of file data into the page cache.  Return the page
  * locked.
@@ -1950,9 +1926,25 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 	if (ret)
 		return ret;
 
-	ret = generic_remap_file_range_target(file_out, remap_flags);
-	if (ret)
-		return ret;
+	if (!(remap_flags & REMAP_FILE_DEDUP)) {
+		/*
+		 * Update the timestamps, since we can alter file contents.
+		 */
+		if (!(file_out->f_mode & FMODE_NOCMTIME)) {
+			ret = file_update_time(file_out);
+			if (ret)
+				return ret;
+		}
+
+		/*
+		 * Clear the security bits if the process is not being run by
+		 * root.  This keeps people from modifying setuid and setgid
+		 * binaries.
+		 */
+		ret = file_remove_privs(file_out);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
