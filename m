Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B354C43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 20:08:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED0E6216E3
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 20:07:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20150623.gappssmtp.com header.i=@osandov-com.20150623.gappssmtp.com header.b="iSKYwS+h"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ED0E6216E3
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbeI1C14 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 22:27:56 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33831 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727266AbeI1C1z (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 22:27:55 -0400
Received: by mail-pf1-f193.google.com with SMTP id k19-v6so2669807pfi.1
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 13:07:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=6zEPJhFpoCFyNM4tmsC6aryQLK3358G02Gg0fO6oC/I=;
        b=iSKYwS+hc8pOSQb4EkcziqXJ+VZbbPfyFf0ky+3pt/sWSUb5+XchyWqeJGeUZCQ+UW
         TRm2Z8Shc92Rpuehhjf8NC8yINRL2MyCPdIJdIkM927HOPcjp6kOQhSXNozGGarIi0Oq
         NH8lKvMZz5ugmvGrml9uwvkptypweRsar6ifjCzv3x3fdkJWG3pJeQjdsPojwd3f9vOG
         o2Ncaasn07y9GK98i54VzLEXKmF+nkI/LhsVQOqsLbcqa+2mBuC7wubed88zvobuPxLG
         2B4iPRpvqho0Rh6y0IvmuiZ2UguCN9+V8l+IJ2EB2nQyry64d2PVMbTPdHtB7rSMbk9d
         OdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=6zEPJhFpoCFyNM4tmsC6aryQLK3358G02Gg0fO6oC/I=;
        b=Nn1+b+SbY4own+Z8+h62jV4fE5H4eA+vA2Z7H3V/v2MrCsPmz0OOwtvmw2+ejzbBES
         Ua2H7nDe3759vb/w8BnWBRZsW0pAKXxzFE9Ombon536eKosEiACa6gVh99xKobowUEWE
         gZ+RhA+EpoMsQwfQLhdOtl9B9vjMjgbBUvnOcF8jm77TMrtXg8EfgSmI0v0SN5/QoQlG
         k8FGDHpweyaoyndua27M0UYoezu/V0CzD56hyZPVRsImNfhOsiiyaNi/LsdJEaGckR/D
         i9QTi3ET7L1XihUajwUt7pyd86uYU+27QlP2hvQ5waS0g+AVbHQs8jry57vgacwYdvTC
         xYtw==
X-Gm-Message-State: ABuFfohvP1s0zMtVPIJvOu4O0W3u6RFySZrJZ4j4Lge4p01QhXBdA3/n
        Zf8Ly+5NkUS5VhvG94bOCmKWGg==
X-Google-Smtp-Source: ACcGV61ZIhFzflCvJ8ura64wFysXJs5EH4I52EPQbbXfw5/1fjiV+6PYGqhJcP/TbecoqgJrSPpk+Q==
X-Received: by 2002:a62:3241:: with SMTP id y62-v6mr13205732pfy.4.1538078876892;
        Thu, 27 Sep 2018 13:07:56 -0700 (PDT)
Received: from vader ([2620:10d:c090:200::5:3e64])
        by smtp.gmail.com with ESMTPSA id i2-v6sm5101132pgq.35.2018.09.27.13.07.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Sep 2018 13:07:56 -0700 (PDT)
Date:   Thu, 27 Sep 2018 13:07:55 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Anand Jain <anand.jain@oracle.com>, fstests@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/9] fstests: btrfs: _scratch_mkfs_sized fix min size
 without mixed option
Message-ID: <20180927200755.GC29754@vader>
References: <1537849462-619-1-git-send-email-anand.jain@oracle.com>
 <1537849462-619-2-git-send-email-anand.jain@oracle.com>
 <b054a402-0507-4990-6752-8d75b02a97ed@suse.com>
 <68c6443f-6d2b-ba3a-40e1-994fa5ee32e3@oracle.com>
 <b6a81bfa-66f6-89e3-3c1e-2d5396f8bbf4@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6a81bfa-66f6-89e3-3c1e-2d5396f8bbf4@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 26, 2018 at 09:34:27AM +0300, Nikolay Borisov wrote:
> 
> 
> On 26.09.2018 07:07, Anand Jain wrote:
> > 
> > 
> > On 09/25/2018 06:51 PM, Nikolay Borisov wrote:
> >>
> >>
> >> On 25.09.2018 07:24, Anand Jain wrote:
> >>> As of now _scratch_mkfs_sized() checks if the requested size is below 1G
> >>> and forces the --mixed option for the mkfs.btrfs. Well the correct size
> >>> considering all possible group profiles at which we need to force the
> >>> mixed option is roughly 256Mbytes. So fix that.
> >>>
> >>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> >>
> >> Have you considered the implications of this w.r.t commit
> >> d4da414a9a9d ("common/rc: raise btrfs mixed mode threshold to 1GB")
> >>
> >> Initially this threshold was 100mb then Omar changed it to 1g. Does this
> >> change affect generic/427?
> > 
> > d4da414a9a9d does not explain what was the problem that Omar wanted to
> > address, mainly what was the failure about.
> 
> I just retested on upstream 4.19.0-rc3 with Omar's patch reverted (so
> anything above 100m for fs size is created with non-mixed block groups)
> and the test succeeded. So indeed your change seems to not make a
> difference for this test.
> 
> > 
> > And no it does not affect. I have verified generic/427 with kernel 4.1
> > and 4.19-rc5 with  btrfs-progs 4.1, 4.9 and latest from kdave they all
> > run fine. Good to integrate.

I had to double check, but it only happens with -m dup. If I apply the
following patch:

diff --git a/common/rc b/common/rc
index d5bb1fe..989b846 100644
--- a/common/rc
+++ b/common/rc
@@ -969,7 +969,7 @@ _scratch_mkfs_sized()
 	;;
     btrfs)
 	local mixed_opt=
-	(( fssize <= 1024 * 1024 * 1024 )) && mixed_opt='--mixed'
+	(( fssize <= 100 * 1024 * 1024 )) && mixed_opt='--mixed'
 	$MKFS_BTRFS_PROG $MKFS_OPTIONS $mixed_opt -b $fssize $SCRATCH_DEV
 	;;
     jfs)
diff --git a/tests/generic/427 b/tests/generic/427
index e8ebffe..206cf08 100755
--- a/tests/generic/427
+++ b/tests/generic/427
@@ -65,6 +65,7 @@ fi
 # start a background aio writer, which does several extending loops
 # internally and check data integrality
 $AIO_TEST -s $fsize -b 65536 $SCRATCH_MNT/tst-aio-dio-eof-race.$seq
+btrfs fi usage $SCRATCH_MNT
 status=$?
 
 kill $open_close_pid

And run with MKFS_OPTIONS="-m dup", then we don't have enough data space
for the test:

--- /root/linux/xfstests/tests/generic/427.out	2017-11-28 16:05:46.811435644 -0800
+++ /root/linux/xfstests/results/generic/427.out.bad	2018-09-27 13:01:00.540510385 -0700
@@ -1,2 +1,24 @@
 QA output created by 427
-Success, all done.
+pwrite: No space left on device
+Overall:
+    Device size:		 256.00MiB
+    Device allocated:		 255.00MiB
+    Device unallocated:		   1.00MiB
+    Device missing:		     0.00B
+    Used:			 179.03MiB
+    Free (estimated):		     0.00B	(min: 0.00B)
+    Data ratio:			      1.00
+    Metadata ratio:		      2.00
+    Global reserve:		  16.00MiB	(used: 0.00B)
+
+Data,single: Size:175.00MiB, Used:175.00MiB
+   /dev/nvme0n1p2	 175.00MiB
+
+Metadata,DUP: Size:32.00MiB, Used:2.00MiB
+   /dev/nvme0n1p2	  64.00MiB
+
+System,DUP: Size:8.00MiB, Used:16.00KiB
+   /dev/nvme0n1p2	  16.00MiB
+
+Unallocated:
+   /dev/nvme0n1p2	   1.00MiB
