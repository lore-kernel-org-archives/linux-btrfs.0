Return-Path: <SRS0=k9FD=SI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CED4C10F06
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 12:02:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B59642087F
	for <linux-btrfs@archiver.kernel.org>; Sat,  6 Apr 2019 12:02:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="onLpXbZQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbfDFMCP (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 6 Apr 2019 08:02:15 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37628 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbfDFMCO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Apr 2019 08:02:14 -0400
Received: by mail-pf1-f194.google.com with SMTP id 8so4789141pfr.4;
        Sat, 06 Apr 2019 05:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=mcrYvKPjo5rQdagr9HjuJ6Pr/3+i6Mk9twbxI0iDPTg=;
        b=onLpXbZQZlYUmC5BftYPIfXFFQicLx/MNa/PhwmBsmLd2PDLYwt0WvRDYM3+l2J1Sd
         F0DUfcg2F1P6jdXnNLtn80QlYyJeGjGkH5zkEwJL5NEsB7xV9jEG+bEvIx8QpcsfUTai
         fXyNt51y0NSs85QEl9DHYZLNZfHaL0T8Ls65bSyFSgFGTNZk8T30o5kKwaqU6EXA1cG8
         s0/Vr4Wd5B+zGrskSk+C77gBDhey3XcwAaNPtmtohX9zldnktR1MhAfrkR880C1lX73F
         6JMKXsFapSnK6dcrLbhGEmgoQaVgOLyU9wMwbx2sehrFJs+qTi8Q3YVp2G9Cm2LRJREy
         tYhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=mcrYvKPjo5rQdagr9HjuJ6Pr/3+i6Mk9twbxI0iDPTg=;
        b=jiHsynvXaRl3F1fUdc+na3gp8ULSlmj2SnDQYbIp9sHYdmHJPKXcjdloMV8T6c9/+L
         FT45+AyqYVsXprl60P6d/SONqs9EfHC2/qe/LypBwzqAyYTQC/VHLXJBwdVNkwV53gT6
         iamm2T74kZPZwFvI5IZokymw9smoZm7gy7J7SmlTqyYnwhvd7YPoGEvO5TBzmq8Fzehy
         ZNn4y2gXvASwEstJaH2RfSoZKXSnlA4tuYjM1seTw0cxVgax1zAfJScxC/KTv6rFJS9F
         8Nn1R4hU1qPpd9L5ZGcv4ITnmTUJJXNpuAJPLHmY+CVL8XDZg+jFHHpIf8NXujG1hWGe
         e6LQ==
X-Gm-Message-State: APjAAAUNuoQra+ffoSkAMZtm0MdaJsB4Eq5P73pgE3+GVphB6+tFZLtx
        SY08uAkzKC2s/R5DplMaqPc=
X-Google-Smtp-Source: APXvYqxNdCTXWQJnPGWimgUAVrfov9OLjlayIqFbYLYgKqu8I+v2KzlaR4acIYe2CF1fj35zqrQ0DQ==
X-Received: by 2002:aa7:8289:: with SMTP id s9mr18214886pfm.208.1554552133625;
        Sat, 06 Apr 2019 05:02:13 -0700 (PDT)
Received: from localhost ([128.199.137.77])
        by smtp.gmail.com with ESMTPSA id g73sm44974591pfd.185.2019.04.06.05.02.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 06 Apr 2019 05:02:12 -0700 (PDT)
Date:   Sat, 6 Apr 2019 20:02:07 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Cc:     Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] fstests: btrfs/048: amend property validation cases
Message-ID: <20190406120207.GG2824@desktop>
References: <20190403165419.12666-1-anand.jain@oracle.com>
 <20190403170437.14448-1-anand.jain@oracle.com>
 <7de2d0fd-e777-2bec-5731-15ba2f2af4f2@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7de2d0fd-e777-2bec-5731-15ba2f2af4f2@suse.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Apr 05, 2019 at 04:21:10PM +0300, Nikolay Borisov wrote:
> 
> 
> On 3.04.19 г. 20:04 ч., Anand Jain wrote:
> > Add more property validation cases which are fixed by the patches [1]
> >  [1]
> >   btrfs: fix vanished compression property after failed set
> >   btrfs: fix zstd compression parameter
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

Thanks for the test and the review!

But this looks like a targeted regression test that may fail an existing
test. It's better to write a new test for this.

Thanks,
Eryu

> 
> > ---
> > v2: correct kernel patch titles in the test header and change log
> > 
> >  tests/btrfs/048     | 23 +++++++++++++++++++++++
> >  tests/btrfs/048.out | 16 ++++++++++++++++
> >  2 files changed, 39 insertions(+)
> > 
> > diff --git a/tests/btrfs/048 b/tests/btrfs/048
> > index 588219579cc6..f6de0b8ca8b1 100755
> > --- a/tests/btrfs/048
> > +++ b/tests/btrfs/048
> > @@ -6,6 +6,9 @@
> >  #
> >  # Btrfs properties test. The btrfs properties feature was introduced in the
> >  # linux kernel 3.14.
> > +# Fails without the kernel patches:
> > +#  btrfs: fix vanished compression property after failed set
> > +#  btrfs: fix zstd compression parameter
> >  #
> >  seq=`basename $0`
> >  seqres=$RESULT_DIR/$seq
> > @@ -34,6 +37,7 @@ _supported_os Linux
> >  _require_test
> >  _require_scratch
> >  _require_btrfs_command "property"
> > +_require_btrfs_command inspect-internal dump-super
> >  
> >  send_files_dir=$TEST_DIR/btrfs-test-$seq
> >  
> > @@ -203,5 +207,24 @@ $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1 compression
> >  touch $SCRATCH_MNT/sv1/file2
> >  $BTRFS_UTIL_PROG property get $SCRATCH_MNT/sv1/file2 compression
> >  
> > +echo -e "\nTesting argument validation, should fail"
> > +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | _filter_scratch
> > +echo "***"
> > +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | _filter_scratch
> > +echo "***"
> > +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zst' | _filter_scratch
> > +
> > +echo -e "\nTesting if property is persistent across failed validation"
> > +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lzo'
> > +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'zli' | _filter_scratch
> > +$BTRFS_UTIL_PROG property get $SCRATCH_MNT compression
> > +
> > +echo -e "\nTesting generation is unchanged after failed validation"
> > +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> > +$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep '^generation'
> > +$BTRFS_UTIL_PROG property set $SCRATCH_MNT compression 'lz' | _filter_scratch
> > +$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT
> > +$BTRFS_UTIL_PROG inspect-internal dump-super $SCRATCH_DEV | grep '^generation'
> > +
> >  status=0
> >  exit
> > diff --git a/tests/btrfs/048.out b/tests/btrfs/048.out
> > index 3e4e3d28950a..00f39bc01227 100644
> > --- a/tests/btrfs/048.out
> > +++ b/tests/btrfs/048.out
> > @@ -76,3 +76,19 @@ compression=zlib
> >  Testing subvolume property inheritance
> >  compression=lzo
> >  compression=lzo
> > +
> > +Testing argument validation, should fail
> > +ERROR: failed to set compression for /mnt/scratch: Invalid argument
> > +***
> > +ERROR: failed to set compression for /mnt/scratch: Invalid argument
> > +***
> > +ERROR: failed to set compression for /mnt/scratch: Invalid argument
> > +
> > +Testing if property is persistent across failed validation
> > +ERROR: failed to set compression for /mnt/scratch: Invalid argument
> > +compression=lzo
> > +
> > +Testing generation is unchanged after failed validation
> > +generation		7
> > +ERROR: failed to set compression for /mnt/scratch: Invalid argument
> > +generation		7
> > 
