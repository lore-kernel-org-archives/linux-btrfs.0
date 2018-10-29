Return-Path: <SRS0=e2uI=NJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5892CC0044C
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 18:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 778A22084A
	for <linux-btrfs@archiver.kernel.org>; Mon, 29 Oct 2018 18:17:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 778A22084A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=rus.uni-stuttgart.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbeJ3DHQ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 29 Oct 2018 23:07:16 -0400
Received: from diaspora.rus.uni-stuttgart.de ([129.69.13.139]:51902 "EHLO
        diaspora.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729037AbeJ3DHQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Oct 2018 23:07:16 -0400
X-Greylist: delayed 349 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Oct 2018 23:07:15 EDT
Received: from diaspora.rus.uni-stuttgart.de (localhost [127.0.0.1])
        by diaspora.rus.uni-stuttgart.de (Postfix) with SMTP id 80C068033E
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Oct 2018 19:11:41 +0100 (CET)
Date:   Mon, 29 Oct 2018 19:11:41 +0100
From:   Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To:     linux-btrfs@vger.kernel.org
Subject: Understanding "btrfs filesystem usage"
Message-ID: <20181029181141.GA31256@rus.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I want to know how many free space is left and have problems in
interpreting the output of: 

btrfs filesystem usage
btrfs filesystem df
btrfs filesystem show


In detail:


root@diaspora:~# btrfs filesystem usage /local
Overall:
    Device size:                 883.51GiB
    Device allocated:            825.51GiB
    Device unallocated:           58.00GiB
    Device missing:                  0.00B
    Used:                        494.45GiB
    Free (estimated):            387.94GiB      (min: 387.94GiB)
    Data ratio:                       1.00
    Metadata ratio:                   1.00
    Global reserve:              320.00MiB      (used: 0.00B)

Data,single: Size:823.47GiB, Used:493.53GiB
   /dev/sda4     823.47GiB

Metadata,single: Size:2.01GiB, Used:938.67MiB
   /dev/sda4       2.01GiB

System,single: Size:32.00MiB, Used:128.00KiB
   /dev/sda4      32.00MiB

Unallocated:
   /dev/sda4      58.00GiB


root@diaspora:~# btrfs filesystem df /local
Data, single: total=823.47GiB, used=493.53GiB
System, single: total=32.00MiB, used=128.00KiB
Metadata, single: total=2.01GiB, used=938.67MiB
GlobalReserve, single: total=320.00MiB, used=0.00B


root@diaspora:~# btrfs filesystem show /local
Label: 'local'  uuid: 11faaa39-5805-4e92-a891-e8ceb4afa9f7
        Total devices 1 FS bytes used 494.45GiB
        devid    1 size 883.51GiB used 825.51GiB path /dev/sda4


What does the last line mean?
825.51GiB used = allocated by (file) data?
In this case I would have only 58 GB free disk space left?

"btrfs filesystem usage" says 494 GB used, but
"btrfs filesystem show" says 825 GB used?!

The man pages do not explain the different meanings of "used" and
"allocated"  

And at last:

root@diaspora:~# df -HT /local
Filesystem     Type   Size  Used Avail Use% Mounted on
/dev/sda4      btrfs  949G  532G  417G  57% /local



-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20181029181141.GA31256@rus.uni-stuttgart.de>
