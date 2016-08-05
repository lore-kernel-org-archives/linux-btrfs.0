Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:36306 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbcHEROj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Aug 2016 13:14:39 -0400
Received: by mail-wm0-f47.google.com with SMTP id q128so38990005wma.1
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Aug 2016 10:14:38 -0700 (PDT)
From: Diego Calleja <diegocalleja@gmail.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Input/output error, nothing appended in dmesg
Date: Fri, 05 Aug 2016 19:14:35 +0200
Message-ID: <4512147.AhYRtkYqCr@archlinux>
In-Reply-To: <e03fc4983421a31251c6f6274dd2c597@admin.virtall.com>
References: <ff95214f4e2dd819d42dee7dff5f6580@admin.virtall.com> <e8e15af203f0f559d46402ee6a296209@admin.virtall.com> <e03fc4983421a31251c6f6274dd2c597@admin.virtall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

El sábado, 6 de agosto de 2016 0:45:13 (CEST) Tomasz Chmielewski escribió:
> And, miracle cure O_o
> 
> # file ./2016-08-02/serverX/syslog.log
> ERROR: cannot read `./2016-08-02/serverX/syslog.log' (Input/output
> error)
> 
> # echo 3 > /proc/sys/vm/drop_caches
> 
> # file 2016-08-02/serverX/syslog.log
> 2016-08-02/serverX/syslog.log: ASCII text, with very long lines

FWIW, bugs similar to this one were reported in the past:

http://www.spinics.net/lists/linux-btrfs/msg54962.html
http://www.spinics.net/lists/linux-btrfs/msg52371.html
