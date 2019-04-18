Return-Path: <SRS0=uOHe=SU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6484C10F14
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 14:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8E2C2083D
	for <linux-btrfs@archiver.kernel.org>; Thu, 18 Apr 2019 14:08:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20150623.gappssmtp.com header.i=@toxicpanda-com.20150623.gappssmtp.com header.b="aSzsIZeC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389104AbfDROH6 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:07:58 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:44723 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388495AbfDROH6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 18 Apr 2019 10:07:58 -0400
Received: by mail-yb1-f194.google.com with SMTP id u187so869039ybg.11
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Apr 2019 07:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=6Rhcg8fa2hBMufpf8gDXTuEh6jV1AGJyMm+dHB6jlq4=;
        b=aSzsIZeC2VCOYFaY/wDpDMvbLd8r1hoayYjR2/SqvBGA8Ul2ndJltAlR14AdRgqOLk
         gDV+BjgrR4+ujUR6Fj4Tk8gavjnKDwGjSH6e6sjuK16ofjDlNdbG5prlG4QrrtPiBc5b
         74Ub+tncarcPLNCMWo63r7yRdHeAew29F1hKSWxKlkZDynzt1h/SFqTXvIzPFkm1C8Qh
         bN/H05IsYlL2MhNswYE0ckoRiOafbLGdny4ap76ssH1JqXKIGZ7SmkH6sGQDbVmIMlSR
         Zyelji2JtsUq1SGrKUsOXSVu3KHTkXoXIJyDPK3TEe8GthHb5BePgRJGLY/cXWylxBRS
         7qoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=6Rhcg8fa2hBMufpf8gDXTuEh6jV1AGJyMm+dHB6jlq4=;
        b=QXmdpftFQHHgJdJP4psKfeqv4SornyyTaCW/5iMDJHjJRWVtGqq/q2hItIzMRLwpqe
         8TMoC4boTEHxMQNTWIMr5ZleLN6mwIvVYmWpYlSWoPOrGo1W7m4oh622a7TNSNedrLcA
         I4dSNi9pnaQr2JTO+HU6xCjzsIfgYx5Uvpj/ojKRxsLsSJ+BiQ2kHu3iV7iRrDrFGjTK
         mQ+NHZW4PXd4bWlo2FmDPfc33B2rMqq48QXe95lqK9YoAxkD3VpyHajsof9R8Nbgaflc
         ZmLyUcn9DHJCWv948046c1fliAyJm9xYadMbfk9GWU6CdNqJc5n5rqmUlt6suxcoyLCu
         ZjyA==
X-Gm-Message-State: APjAAAX38GcwczfxQRvM+WCFlZOdWbKpqTk8LLwg/fN4t9vZb4MiSf1n
        hjnI9kKu/6x6OlhiQ1X1iM+0cg==
X-Google-Smtp-Source: APXvYqxxPbJ9F6pQeenxM7SyFc9brEmgdWi3MEvQtFrXDNHG+26n28pyskFC+3p52HEbpuMH0DjNUw==
X-Received: by 2002:a25:d7c1:: with SMTP id o184mr29496615ybg.147.1555596477100;
        Thu, 18 Apr 2019 07:07:57 -0700 (PDT)
Received: from localhost ([2620:10d:c091:180::e445])
        by smtp.gmail.com with ESMTPSA id 74sm746578ywe.81.2019.04.18.07.07.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Apr 2019 07:07:56 -0700 (PDT)
Date:   Thu, 18 Apr 2019 10:07:54 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Pan Bian <bianpan2016@163.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V2] btrfs: drop inode reference count on error path
Message-ID: <20190418140749.h57y5kqz4s47sbuo@macbook-pro-91.dhcp.thefacebook.com>
References: <1555585576-31045-1-git-send-email-bianpan2016@163.com>
 <ac36d111-547e-a76a-149e-a7ad603d7dfd@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac36d111-547e-a76a-149e-a7ad603d7dfd@suse.com>
User-Agent: NeoMutt/20180716
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Apr 18, 2019 at 03:50:00PM +0300, Nikolay Borisov wrote:
> 
> 
> On 18.04.19 г. 14:06 ч., Pan Bian wrote:
> > The reference count of inode is incremented by ihold. It should be
> > dropped if not used. However, the reference count is not dropped if
> > error occurs during updating the inode or deleting orphan items. This
> > patch fixes the bug.
> > 
> > Signed-off-by: Pan Bian <bianpan2016@163.com>
> > ---
> > V2: move ihold just before device_initialize to make code clearer
> > ---
> >  fs/btrfs/inode.c | 54 +++++++++++++++++++++++++-----------------------------
> >  1 file changed, 25 insertions(+), 29 deletions(-)
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 82fdda8..d6630df 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -6579,7 +6579,7 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
> >  	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> >  	u64 index;
> >  	int err;
> > -	int drop_inode = 0;
> > +	int log_mode;
> >  
> >  	/* do not allow sys_link's with other subvols of the same device */
> >  	if (root->root_key.objectid != BTRFS_I(inode)->root->root_key.objectid)
> > @@ -6616,41 +6616,37 @@ static int btrfs_link(struct dentry *old_dentry, struct inode *dir,
> >  	err = btrfs_add_nondir(trans, BTRFS_I(dir), dentry, BTRFS_I(inode),
> >  			1, index);
> >  
> > -	if (err) {
> > -		drop_inode = 1;
> > -	} else {
> > -		struct dentry *parent = dentry->d_parent;
> > -		int ret;
> > +	if (err)
> > +		goto err_link;
> >  
> > -		err = btrfs_update_inode(trans, root, inode);
> > +	err = btrfs_update_inode(trans, root, inode);
> > +	if (err)
> > +		goto err_link;
> > +	if (inode->i_nlink == 1) {
> > +		/*
> > +		 * If new hard link count is 1, it's a file created
> > +		 * with open(2) O_TMPFILE flag.
> > +		 */
> > +		err = btrfs_orphan_del(trans, BTRFS_I(inode));
> >  		if (err)
> > -			goto fail;
> > -		if (inode->i_nlink == 1) {
> > -			/*
> > -			 * If new hard link count is 1, it's a file created
> > -			 * with open(2) O_TMPFILE flag.
> > -			 */
> > -			err = btrfs_orphan_del(trans, BTRFS_I(inode));
> > -			if (err)
> > -				goto fail;
> > -		}
> > -		BTRFS_I(inode)->last_link_trans = trans->transid;
> > -		d_instantiate(dentry, inode);
> > -		ret = btrfs_log_new_name(trans, BTRFS_I(inode), NULL, parent,
> > -					 true, NULL);
> > -		if (ret == BTRFS_NEED_TRANS_COMMIT) {
> > -			err = btrfs_commit_transaction(trans);
> > -			trans = NULL;
> > -		}
> > +			goto err_link;
> > +	}
> > +	BTRFS_I(inode)->last_link_trans = trans->transid;
> > +	ihold(inode);

Where is the iput for this ihold?

Josef
