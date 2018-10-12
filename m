Return-Path: <SRS0=eG6O=MY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28B0C71122
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 20:22:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AD62205F4
	for <linux-btrfs@archiver.kernel.org>; Fri, 12 Oct 2018 20:22:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lb04MRWL"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AD62205F4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbeJMD4m (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 12 Oct 2018 23:56:42 -0400
Received: from mail-ua1-f66.google.com ([209.85.222.66]:42108 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbeJMD4m (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 12 Oct 2018 23:56:42 -0400
Received: by mail-ua1-f66.google.com with SMTP id c1so12521uaq.9;
        Fri, 12 Oct 2018 13:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=O99/+EiYy00XgATUXpvtb3vKNljMACK4yCPGdPq6d1k=;
        b=Lb04MRWLLfsBKSHqYYHzDSPfzblH0Y2AMyWvcqKr5SfEWs/Kn7Oszt7PHxjLVLtW6Y
         MWrLuJok2lTMrDocEaUWymSlAm2vDe04nAYlCy2xl+C9d7tCGW1JryTLUv3Pqimxl2d7
         TOOpwkN0oVywMMpJ0LJDtTcs5d0nWlRl9KT62lFneMWMI2WZfPd0xGg/tKXHrjvcB0cX
         n7kuWW8waNlt4gR9mWxomgIk9fCJMj2ILyU57jCkTB4791jRuH/OQEzpNU+6AA2wdjXd
         MBgs9JMXSUM5Q8rBT/J0stwBHgRmqJ/no0GjqI4WLTs1gh/ohaOdKVojjNoqZzcevWdH
         vMKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=O99/+EiYy00XgATUXpvtb3vKNljMACK4yCPGdPq6d1k=;
        b=fxK7UVab/dCibyuKlExUgSUJc0ZGoJoG9jVvOVqKWnsme+qiKnPR3m91YDCOQEt/52
         GIzRJmo4Ygtkas6FwPTGOOOArHF2Y2h6OxTIF55n9stgu3ZCX8FgtkKzEW+LWFtsqvyw
         Da+yml2yaCOFTyOu5bhxeFxe2LqExXUJFMumkhmMsC8hGMdKEpFqhzlqZ97/cjqSxzZA
         SrNbQ6EhQuSn+jv6WDmFU7ZI9Z7q+NPDT7IV4HM7LU3NCHM1kzMi7v651wxIWj0v+J7t
         HvUip+OzHau2CqVWEAwbgvbS3FdCOmWNCGd7o8cRX0EhsyYuqFuWQnKk4rRupcOOT9XN
         Wcog==
X-Gm-Message-State: ABuFfogHyZ/WhQFecFFBcbJme2a5tl3KFovPDXJs577tNVHKts6Jme7l
        IDogvzZJHbsPGgTPtlnCfAw9cqOi08EGYsT63Qc=
X-Google-Smtp-Source: ACcGV63DUxaSFRp6wzmh/pOlNpluSIu9YjM+Tt6MsmJgHkM+xbMhHuNbkLB4G7vnO/74zrqKL+eUXxgxgU/laTU/0Pc=
X-Received: by 2002:a9f:2c0b:: with SMTP id r11mr1609105uaj.100.1539375749783;
 Fri, 12 Oct 2018 13:22:29 -0700 (PDT)
MIME-Version: 1.0
References: <153923113649.5546.9840926895953408273.stgit@magnolia> <153923117420.5546.13317703807467393934.stgit@magnolia>
In-Reply-To: <153923117420.5546.13317703807467393934.stgit@magnolia>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 12 Oct 2018 21:22:18 +0100
Message-ID: <CAL3q7H7mLvCGpyitJhQ=To-aDvG9k9rxSVi2jSpcALQVj3myzg@mail.gmail.com>
Subject: Re: [PATCH 05/25] vfs: avoid problematic remapping requests into
 partial EOF block
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Eric Sandeen <sandeen@redhat.com>, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org,
        linux-xfs@vger.kernel.org, linux-mm@kvack.org,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        ocfs2-devel@oss.oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Oct 11, 2018 at 5:13 AM Darrick J. Wong <darrick.wong@oracle.com> w=
rote:
>
> From: Darrick J. Wong <darrick.wong@oracle.com>
>
> A deduplication data corruption is exposed by fstests generic/505 on
> XFS.

(and btrfs)

Btw, the generic test I wrote was indeed numbered 505, however it was
never committed and there's now a generic/505 which has nothing to do
with deduplication.
So you should update the changelog to avoid confusion.

thanks

> It is caused by extending the block match range to include the
> partial EOF block, but then allowing unknown data beyond EOF to be
> considered a "match" to data in the destination file because the
> comparison is only made to the end of the source file. This corrupts the
> destination file when the source extent is shared with it.
>
> The VFS remapping prep functions  only support whole block dedupe, but
> we still need to appear to support whole file dedupe correctly.  Hence
> if the dedupe request includes the last block of the souce file, don't
> include it in the actual dedupe operation. If the rest of the range
> dedupes successfully, then reject the entire request.  A subsequent
> patch will enable us to shorten dedupe requests correctly.
>
> When reflinking sub-file ranges, a data corruption can occur when the
> source file range includes a partial EOF block. This shares the unknown
> data beyond EOF into the second file at a position inside EOF, exposing
> stale data in the second file.
>
> If the reflink request includes the last block of the souce file, only
> proceed with the reflink operation if it lands at or past the
> destination file's current EOF. If it lands within the destination file
> EOF, reject the entire request with -EINVAL and make the caller go the
> hard way.  A subsequent patch will enable us to shorten reflink requests
> correctly.
>
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/read_write.c |   22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
>
> diff --git a/fs/read_write.c b/fs/read_write.c
> index d6e8e242a15f..8498991e2f33 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1723,6 +1723,7 @@ int vfs_clone_file_prep(struct file *file_in, loff_=
t pos_in,
>  {
>         struct inode *inode_in =3D file_inode(file_in);
>         struct inode *inode_out =3D file_inode(file_out);
> +       u64 blkmask =3D i_blocksize(inode_in) - 1;
>         bool same_inode =3D (inode_in =3D=3D inode_out);
>         int ret;
>
> @@ -1785,6 +1786,27 @@ int vfs_clone_file_prep(struct file *file_in, loff=
_t pos_in,
>                         return -EBADE;
>         }
>
> +       /* Are we doing a partial EOF block remapping of some kind? */
> +       if (*len & blkmask) {
> +               /*
> +                * If the dedupe data matches, don't try to dedupe the pa=
rtial
> +                * EOF block.
> +                *
> +                * If the user is attempting to remap a partial EOF block=
 and
> +                * it's inside the destination EOF then reject it.
> +                *
> +                * We don't support shortening requests, so we can only r=
eject
> +                * them.
> +                */
> +               if (is_dedupe)
> +                       ret =3D -EBADE;
> +               else if (pos_out + *len < i_size_read(inode_out))
> +                       ret =3D -EINVAL;
> +
> +               if (ret)
> +                       return ret;
> +       }
> +
>         return 1;
>  }
>  EXPORT_SYMBOL(vfs_clone_file_prep);
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
