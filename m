Return-Path: <SRS0=C9fc=QR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB11C282C2
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Feb 2019 07:09:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17A8B21736
	for <linux-btrfs@archiver.kernel.org>; Sun, 10 Feb 2019 07:09:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=shaw.ca header.i=@shaw.ca header.b="Sb0F8lnC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfBJHEl (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 10 Feb 2019 02:04:41 -0500
Received: from smtp-out-no.shaw.ca ([64.59.134.13]:54206 "EHLO
        smtp-out-no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbfBJHEk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Feb 2019 02:04:40 -0500
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Feb 2019 02:04:40 EST
Received: from cds126.dcs.int.inet ([10.0.153.159])
        by shaw.ca with ESMTP
        id sj2VgO4pRMRX3sj2Wg8Y46; Sat, 09 Feb 2019 23:56:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shaw.ca;
        s=s20180605; t=1549781792;
        bh=fGVbjf5ku6ot3H2hfaBV91ze1C9pVKnxT/23piD7soo=;
        h=Date:From:To:Subject;
        b=Sb0F8lnCMalTY2nAB6BXPFt34V5EzsnJLckd2UBt3MHk9ktpELPIsdQw/FphWAJ+Q
         s2iVEx4n8uuqOaxtsUgDJ2c+tCU4O/jxVO3K6NxLX99dXb/a5PZXDWk2CEyMqjR7Yu
         lI0reTzcLuupkSSp55kzjZxUqSU34gg0vNU9Q1tjRIc8Dsto6DOxfuXl/+hkNVvNzg
         8w+e6JeYK7y4XngnpbYIHySnspCNpaJOF6GrYH3XSvlGGuaTw5jab0SvsVMDrHzSXr
         RN6zMS7cojSdoBFgdPQncI9iotCGyk5T0AgOOwlX2g3xX5Wjnr46jEMoPpFakpQUPX
         8sOLK+4kDZUmg==
X-Authority-Analysis: v=2.3 cv=TL87tGta c=1 sm=1 tr=0
 a=EkTsUpOA0cE3MUbiN07fnA==:117 a=FKkrIqjQGGEA:10 a=GyfE53u7cosA:10
 a=IkcTkHD0fZMA:10 a=UpmN742d0uRpskKn3lkA:9 a=QEXdDO2ut3YA:10
 a=pHzHmUro8NiASowvMSCR:22 a=nt3jZW36AmriUCFCBwmW:22
Date:   Sat, 9 Feb 2019 23:56:31 -0700 (MST)
From:   STEVE LEUNG <sjleung@shaw.ca>
To:     linux-btrfs@vger.kernel.org
Message-ID: <1690578645.233565651.1549781791550.JavaMail.zimbra@shaw.ca>
Subject: corruption with multi-device btrfs + single bcache, won't mount
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.73.161.213, 24.67.29.113]
X-Mailer: Zimbra 8.6.0_GA_1240 (ZimbraWebClient - FF64 (Linux)/8.6.0_GA_1240)
Thread-Topic: corruption with multi-device btrfs + single bcache, won't mount
Thread-Index: osMLtEW6Vfs4gThJifywE6nXCSDs/A==
X-CMAE-Envelope: MS4wfP0KYP09/g3tc7jdEmfYj1DVrNDCz1BTH0W6cZLn5SjgZ3xhC3fO1GyqvMbvOMF1RZUj6qZ1gg8v0p+KC7iwcDyajqXQB3PM/fYcxfRzR2E3ESc7K/CC
 NWoKNIX0+nNyfdhyLwWDzDsrAmnJScQ65/GVod7uUajARGC+9gPBhEp/PO3mq+aL+vlrLKBuYlXOLg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi all,

I decided to try something a bit crazy, and try multi-device raid1 btrfs on
top of dm-crypt and bcache.  That is:

  btrfs -> dm-crypt -> bcache -> physical disks

I have a single cache device in front of 4 disks.  Maybe this wasn't
that good of an idea, because the filesystem went read-only a few
days after setting it up, and now it won't mount.  I'd been running
btrfs on top of 4 dm-crypt-ed disks for some time without any
problems, and only added bcache (taking one device out at a time,
converting it over, adding it back) recently.

This was on Arch Linux x86-64, kernel 4.20.1.

dmesg from a mount attempt (using -o usebackuproot,nospace_cache,clear_cache):

  [  267.355024] BTRFS info (device dm-5): trying to use backup root at mount time
  [  267.355027] BTRFS info (device dm-5): force clearing of disk cache
  [  267.355030] BTRFS info (device dm-5): disabling disk space caching
  [  267.355032] BTRFS info (device dm-5): has skinny extents
  [  271.446808] BTRFS error (device dm-5): parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
  [  271.447485] BTRFS error (device dm-5): parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
  [  271.447491] BTRFS error (device dm-5): failed to read block groups: -5
  [  271.455868] BTRFS error (device dm-5): open_ctree failed

btrfs check:

  parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
  parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
  parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
  parent transid verify failed on 13069706166272 wanted 4196588 found 4196585
  Ignoring transid failure
  ERROR: child eb corrupted: parent bytenr=13069708722176 item=7 parent level=2 child level=0
  ERROR: cannot open file system

Any simple fix for the filesystem?  It'd be nice to recover the data
that's hopefully still intact.  I have some backups that I can dust
off if it really comes down to it, but it's more convenient to
recover the data in-place.

This is complete speculation, but I do wonder if having the single
cache device for multiple btrfs disks triggered the problem.

Thanks for any assistance.

Steve
