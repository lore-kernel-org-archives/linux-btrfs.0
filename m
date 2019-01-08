Return-Path: <SRS0=Si37=PQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	URIBL_DBL_SPAM autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D9FAC43387
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 12:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3E66206BB
	for <linux-btrfs@archiver.kernel.org>; Tue,  8 Jan 2019 12:26:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YZhceEUg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbfAHM0M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 8 Jan 2019 07:26:12 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42506 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728859AbfAHM0M (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2019 07:26:12 -0500
Received: by mail-ed1-f66.google.com with SMTP id y20so4001666edw.9
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Jan 2019 04:26:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=BYByLAZ3X8lVv+82tO8TkyaaeJTFu+PiO3a9mEeSW4k=;
        b=YZhceEUgU7NO/jvYOXYApB9Hnx3HvUDJ0Ipcj5xX6Y9AW1Z23ZS3DdcOia9Uc9CF+j
         9f7ntqvcdet7M5t2oYz1HIcDQPpe+r8gJqKxJB5LuFlppGNdkTeLRjcqxcX5BzRoHGxf
         SKPTCjEyLOuFCfLgu9uYArC/y0dZXF7AaDZuPdD+yDqKzUYP1wUv/zbdgcJ0BmUT46BQ
         RqOjJAgT41FCWiV/MGxD+bKiFKfz+U56hbzHY0UXCPhOaWMWdMR3+hS14z3C575oHlA0
         HO8QED01kI3xWUfbiPojd5sB3H63eF/4eWsuTX/2RVnBRWou8zyjl2r6JwRWiHa/+QXl
         wf7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=BYByLAZ3X8lVv+82tO8TkyaaeJTFu+PiO3a9mEeSW4k=;
        b=qSdf2CIb6+3fvtjW3Bh7nQ14iH5r9VPzU5EP3eG4P6dz5EMqz/4cp3nhlhRMsNGDTu
         2aU4kfN69NyI2O3fYOtBpeNs469ic6w46lVyIwzu4ry4Xyb3cl7IN3OOZ1FuhjjCmVGQ
         2yBPzL7vl9lw1lkp4aemIHtZA9JOeI8mnFcDC/FTnJO6DHWqrkTx+1dx/hyRwinJdfeY
         BBi9WsadUz55PwmeS2RGthU9vHtX57PMo0qZBYumOYCo+gWkFPaSWkmfDaQYMiiNJtFF
         iyfV8hQE92KHlP/btMruwGWSjd4d16H79x04vRQvSbmskcjCI0YaUHw9+QaEKufMrglj
         XGBg==
X-Gm-Message-State: AJcUukdrjW4ObVkb5tMfwdK0eJVV6gsC0IGtDHVM4Yt807ne3VeZqgTU
        vdsbJPsrIm4i2LAgz4mSE4G+DlMlax0=
X-Google-Smtp-Source: ALg8bN61i4PIXyec9oqRolA8NuwpYrbQ/0DitbVuLgshZrgZWZgVrmywSa9ueIR7KRQ0h45UsZulWQ==
X-Received: by 2002:a05:6402:511:: with SMTP id m17mr1938052edv.33.1546950369881;
        Tue, 08 Jan 2019 04:26:09 -0800 (PST)
Received: from ?IPv6:2001:16b8:60c4:300:41c4:7035:3ec8:b702? (200116b860c4030041c470353ec8b702.dip.versatel-1u1.de. [2001:16b8:60c4:300:41c4:7035:3ec8:b702])
        by smtp.gmail.com with ESMTPSA id r42sm32628265edd.23.2019.01.08.04.26.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Jan 2019 04:26:09 -0800 (PST)
To:     linux-btrfs@vger.kernel.org
From:   Tim Janik <timj.lists@gmail.com>
Subject: Howto fix uncorrectable errors on single disk (error details: csum=1)
Message-ID: <e0813d04-e6a8-f879-ec3c-2e68962d6ce2@gmail.com>
Date:   Tue, 8 Jan 2019 13:26:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hey All.

After a power failure, I encountered a checksum error on a backup disk,
reported by btrfs scrub. I failed to identify any particular file
affected by the reported "error at logical 250492215296".

How do I get rid of the corruption reported by btrfs scrub?
Since this is a backup disk, deleting any affected file or snapshot
would be fine.

uname -a
Linux dozer 4.15.0-43-generic #46-Ubuntu SMP Thu Dec 6 14:45:28 UTC 2018 x86_64
x86_64 x86_64 GNU/Linux

btrfs --version
btrfs-progs v4.15.1

btrfs fi show
Label: 'BtrfsBackups'  uuid: bacbfa3e-b200-4ed4-888c-e2cdf5ca3ed8
        Total devices 1 FS bytes used 2.23TiB
        devid    1 size 3.64TiB used 2.58TiB path /dev/mapper/d6

btrfs fi df /backup
Data, single: total=2.54TiB, used=2.23TiB
System, DUP: total=64.00MiB, used=368.00KiB
Metadata, DUP: total=18.00GiB, used=5.49GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

dmesg
[278033.156632] BTRFS info (device dm-2): use zstd compression, level 0
[278033.156635] BTRFS info (device dm-2): enabling auto defrag
[278033.156637] BTRFS info (device dm-2): disk space caching is enabled
[278033.156638] BTRFS info (device dm-2): has skinny extents
[278033.250808] BTRFS info (device dm-2): bdev /dev/mapper/d6 errs: wr 0, rd 0,
flush 0, corrupt 4, gen 0
[296190.630316] BTRFS error (device dm-2): bdev /dev/mapper/d6 errs: wr 0, rd 0,
flush 0, corrupt 5, gen 0
[296190.630326] BTRFS error (device dm-2): unable to fixup (regular) error at
logical 250492215296 on dev /dev/mapper/d6
[300491.284115] perf: interrupt took too long (4959 > 4958), lowering
kernel.perf_event_max_sample_rate to 40250
[321935.768710] BTRFS info (device dm-2): use zstd compression, level 0
[321935.768714] BTRFS info (device dm-2): enabling auto defrag
[321935.768716] BTRFS info (device dm-2): disk space caching is enabled
[321935.768717] BTRFS info (device dm-2): has skinny extents
[321935.866552] BTRFS info (device dm-2): bdev /dev/mapper/d6 errs: wr 0, rd 0,
flush 0, corrupt 5, gen 0

btrfs scrub status /backup/
scrub status for bacbfa3e-b200-4ed4-888c-e2cdf5ca3ed8
        scrub started at Tue Jan  8 05:01:02 2019 and finished after 04:16:48
        total bytes scrubbed: 2.24TiB with 1 errors
        error details: csum=1
        corrected errors: 0, uncorrectable errors: 1, unverified errors: 0

btrfs inspect-internal logical-resolve 250492215296 /backup/
<NO-OUTPUT>


-- 
Yours sincerely,
Tim Janik

https://testbit.eu/timj
Free software author

