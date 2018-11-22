Return-Path: <SRS0=krA0=OB=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F64C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 05:41:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B99320685
	for <linux-btrfs@archiver.kernel.org>; Thu, 22 Nov 2018 05:41:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=etsukata-com.20150623.gappssmtp.com header.i=@etsukata-com.20150623.gappssmtp.com header.b="kPBsbEU8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B99320685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=etsukata.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392184AbeKVQSz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 22 Nov 2018 11:18:55 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:46797 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731310AbeKVQSz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Nov 2018 11:18:55 -0500
Received: by mail-io1-f65.google.com with SMTP id v10so135372ios.13
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Nov 2018 21:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=etsukata-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hX2Ohql5U41ZW8lMs3Fh05MR5atCa4yFnzGd/atALhY=;
        b=kPBsbEU8eKMYynpjMYz3j19hyt46jWp8Jsn9nNpRlBe8fhCyXb2XDlszuhkfWoflwq
         eGSiJp/n5qzVQ5VFbYGKX/6TxVTHJcNKI7X53ep7KMGzjzgiVTkVN5IuYdx6XIFWdlNT
         ewhMf3jV6mZeFyN1Nr9XNS0fL3ODEcosh7IlfDA2qvwzgSLGfGkAlpJ17KIqNgpsRyOe
         hSVGqFxQYHqfUWYWef0onr0y4cwnRbVW8iCEJE8FiASbKjEpihk+tcNT+kSuOvGU7bqk
         f5ylhJU3t8FkdtQPC94Ls4KUHJqiMIXRLM4ZCC6XpbNHVDDigrKL/NbzxoYFJcxQX6nV
         wmyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hX2Ohql5U41ZW8lMs3Fh05MR5atCa4yFnzGd/atALhY=;
        b=hW46SiKlKW8ZDAsOdtXKYgcFEfnFhhJ2JtcmoyNyASKPgXpqc4v/mExHBGaIMHgYw0
         woMv5aaaeEiJ48x5LSjV+kfIew/++UGPn4AeWTF6nZzbE3CPwj/qf3H5PM2B+W+bGXLL
         qiHmDovgs9bu+KIlly0855bK0T9nrN00UwCbOoMRcQWSXVY7kwInxJQ0apTYeLuPj7oU
         oH+u3cwhS1xXk013whTi0f+9vua8Yj13kR06olP7rvt/dR+vtyrmCL49omdev5Q/By+Q
         B0Qztdd0swLUBv2cOwh4T561WJcQMiw5pbDs88Z/cvN/LCCEtr0brbPevx4d3FQPmmHM
         ZUQQ==
X-Gm-Message-State: AA+aEWYrVnv6mGD3PlDbKrbJfG5Nq3izigeIbPkhUc8kYFZ82qsSyp5f
        f9MYVR33ZSlBIi3ddafQxeuk3iyNPUIOH9OWJyq4lA==
X-Google-Smtp-Source: AFSGD/WQk6xj1ZtgRpv9FbG6qM1vRYlWbukVCLdjYL3inJK3IAmd+kErH3HOI8FLBJhelyRwv1o2MXgyFKij+NMf1/Y=
X-Received: by 2002:a5e:c001:: with SMTP id u1mr2544366iol.152.1542865265776;
 Wed, 21 Nov 2018 21:41:05 -0800 (PST)
MIME-Version: 1.0
References: <20181121024400.4346-1-devel@etsukata.com> <20181121045440.GM32577@ZenIV.linux.org.uk>
In-Reply-To: <20181121045440.GM32577@ZenIV.linux.org.uk>
From:   Eiichi Tsukata <devel@etsukata.com>
Date:   Thu, 22 Nov 2018 14:40:50 +0900
Message-ID: <CANhTXPQzKmsyPO9QrGz6eijjuMFzLN4BhUV=6ABDJysX0xyKfw@mail.gmail.com>
Subject: Re: [PATCH v1 0/4] fs: fix race between llseek SEEK_END and write
To:     Alexander Viro <viro@zeniv.linux.org.uk>
Cc:     andi@firstfloor.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

2018=E5=B9=B411=E6=9C=8821=E6=97=A5(=E6=B0=B4) 13:54 Al Viro <viro@zeniv.li=
nux.org.uk>:
>
> On Wed, Nov 21, 2018 at 11:43:56AM +0900, Eiichi Tsukata wrote:
> > Some file systems (including ext4, xfs, ramfs ...) have the following
> > problem as I've described in the commit message of the 1/4 patch.
> >
> >   The commit ef3d0fd27e90 ("vfs: do (nearly) lockless generic_file_llse=
ek")
> >   removed almost all locks in llseek() including SEEK_END. It based on =
the
> >   idea that write() updates size atomically. But in fact, write() can b=
e
> >   divided into two or more parts in generic_perform_write() when pos
> >   straddles over the PAGE_SIZE, which results in updating size multiple
> >   times in one write(). It means that llseek() can see the size being
> >   updated during write().
>
> And?  Who has ever promised anything that insane?  write(2) can take an a=
rbitrary
> amount of time; another process doing lseek() on independently opened des=
criptor
> is *not* going to wait for that (e.g. page-in of the buffer being written=
, which
> just happens to be mmapped from a file on NFS over RFC1149 link).

Thanks.

The lock I added in NFS was nothing but slow down lseek() because a file si=
ze is
updated atomically. Even `spin_lock(&inode->i_lock)` is unnecessary.

I'll fix the commit message which only refers to specific local file
systems that use
generic_perform_write() and remove unnecessary locks in some
distributed file systems
(e.g. nfs, cifs, or more) by replacing generic_file_llseek() with
generic_file_llseek_unlocked()
so that `tail` don't have to wait for avian carriers.
