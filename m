Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6C7C43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 634BA20850
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 11:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pvt9IA2A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbfAHLRD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 06:17:03 -0500
Received: from mail-vs1-f67.google.com ([209.85.217.67]:43317 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727295AbfAHLRD (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 06:17:03 -0500
Received: by mail-vs1-f67.google.com with SMTP id x1so2198406vsc.10
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 03:17:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc:content-transfer-encoding;
        bh=rW8gHumgRLDDDe958btNvq/gzgu5i0g+fEqKUe8pXT8=;
        b=Pvt9IA2Af+vcqqHhDAr7cyjlXCQfrCntlj1Xah5C1evLZ+J3/b9SxLkM7EwZ/XbP5+
         Z1zSSuXGnwAhbOuFqcgrcwJCkr9ly+SiG/mGkRanzMO77wk/TUW8XWJaist4gpZADezY
         sQW28rpHCbK9OiXWVoQOiEod+kn6caXRgGWX4IIFARpePR2MtmFFQ6hQpPpyDleLRcE8
         894JU3wdtElYd1luCZc9rZdyCOpmrRrlM5Z/dJgcBkE8egoWTSCCav4A3cXHPru7cfk9
         aAmMZDW3IgNGjuD1Sgo5PeuYdGOH/nhp1Z5IprnHbosCPUA6/e2VsC6v6pgfY7w6pSiK
         KN9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc:content-transfer-encoding;
        bh=rW8gHumgRLDDDe958btNvq/gzgu5i0g+fEqKUe8pXT8=;
        b=StGfVIRAfTI5nSIpl7cZt23DgoyM0ZQalEOvEWMukLbwyIqZSPHmWxPOPj2BVkIy7k
         EcTkgYH0Njjz7FdbFULk3uAckCRqW96KutEncPeQTExX2pIMezvqJKEqxjhGKi+QZwUu
         1wyQ1fF3AX0N1pgOGnLdQmkFfvXTGxz49PocBzdhmOfo1+kKcUKWlhhEpzT/nkCPj+I/
         BwmtrXQaPa2yot46Y/rMfloL359htocXlrfE341Cwlz6DuktqyMP6qKObBZxTuECkK7/
         qcepYEup4o67ZPmAB0YPBoVhOa3HhFEUji7w+x86xpbxyMh4b8BTR5BeyxrWCK7Fi3QA
         /sAg==
X-Gm-Message-State: AJcUukeUYOHLsQCJjp9CKflmDOJPFD3IwmNYQaieXrGD+tY2+wrsdo3D
        ktGonSq+5uBuUoEhlIowXgWwHFhjl0FKmfEmRSg=
X-Google-Smtp-Source: ALg8bN50ZjVq4EwINLDxn31V6LmzYqAXtVYXRddNaiD62K38UKQ6cx1Etlxmyl/CHE06HOW9vc+Pkk593m4fzV/7aj8=
X-Received: by 2002:a67:3b1b:: with SMTP id i27mr542974vsa.14.1546946221966;
 Tue, 08 Jan 2019 03:17:01 -0800 (PST)
MIME-Version: 1.0
References: <20190108060818.9517-1-wqu@suse.com>
In-Reply-To: <20190108060818.9517-1-wqu@suse.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Tue, 8 Jan 2019 11:16:50 +0000
Message-ID: <CAL3q7H74TjWQ=kj6V_j9mOJJB45vHpXhAXo__FjB-H+f70tOsg@mail.gmail.com>
Subject: Re: [For 5.0-rc PATCH] btrfs: Use real device structure to verify dev extent
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jan 8, 2019 at 6:11 AM Qu Wenruo <wqu@suse.com> wrote:
>
> [BUG]
> Linux v5.0-rc1 will fail fstests/btrfs/163 with the following kernel
> message:
>
>   BTRFS error (device dm-6): dev extent devid 1 physical offset 13631488 =
len 8388608 is beyond device boundary 0
>   BTRFS error (device dm-6): failed to verify dev extents against chunks:=
 -117
>   BTRFS error (device dm-6): open_ctree failed
>
> [CAUSE]
> Commit cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev extent
> mapping check") introduced strict check on dev extents.
>
> We use btrfs_find_device() with dev uuid and fs uuid set to NULL, and
> only dependent on @devid to find the real device.
>
> For seed devices, we call clone_fs_devices() in open_seed_devices() to
> allow us search seed devices directly.
>
> However clone_fs_devices() just populates devices with devid and dev
> uuid, without populating other essential members, like disk_total_bytes.
>
> This makes any device returned by btrfs_find_device(fs_info, devid,
> NULL, NULL) is just a dummy, with 0 disk_total_bytes, and any dev
> extents on the seed device will not pass the device boundary check.
>
> [FIX]
> This patch will try to verify the device returned by btrfs_find_device()
> and if it's a dummy then re-search in seed devices.
>
> Reported-by: Filipe Manana <fdmanana@suse.com>
> Fixes: cf90d884b347 ("btrfs: Introduce mount time chunk <-> dev extent ma=
pping check")
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  fs/btrfs/volumes.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> index 2576b1a379c9..3e4f8f88353e 100644
> --- a/fs/btrfs/volumes.c
> +++ b/fs/btrfs/volumes.c
> @@ -7825,6 +7825,18 @@ static int verify_one_dev_extent(struct btrfs_fs_i=
nfo *fs_info,
>                 ret =3D -EUCLEAN;
>                 goto out;
>         }
> +
> +       /* It's possible this device is a dummy for seed device */
> +       if (dev->disk_total_bytes =3D=3D 0) {
> +               dev =3D find_device(fs_info->fs_devices->seed, devid, NUL=
L);
> +               if (!dev) {
> +                       btrfs_err(fs_info, "failed to find seed devid %ll=
u",
> +                                 devid);
> +                       ret =3D -EUCLEAN;
> +                       goto out;
> +               }
> +       }

Why just not pass the FSID (can be taken from fs_info->super_copy) to
the previous call to btrfs_find_device()?
It's a lot simpler.

> +
>         if (physical_offset + physical_len > dev->disk_total_bytes) {
>                 btrfs_err(fs_info,
>  "dev extent devid %llu physical offset %llu len %llu is beyond device bo=
undary %llu",
> --
> 2.20.1
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
