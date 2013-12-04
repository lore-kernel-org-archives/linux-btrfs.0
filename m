Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:45751 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256Ab3LDUv7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 4 Dec 2013 15:51:59 -0500
Received: by mail-ie0-f176.google.com with SMTP id at1so27197641iec.21
        for <linux-btrfs@vger.kernel.org>; Wed, 04 Dec 2013 12:51:59 -0800 (PST)
Received: from [192.168.1.5] ([208.78.206.26])
        by mx.google.com with ESMTPSA id i11sm6235250igh.0.2013.12.04.12.51.57
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Wed, 04 Dec 2013 12:51:58 -0800 (PST)
Message-ID: <529F95E8.9000409@gmail.com>
Date: Wed, 04 Dec 2013 15:51:52 -0500
From: Kyle Evans <kvans32@gmail.com>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Can scrub also refresh?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Basically, is there a way to force the refresh of the magnetic state of
data? I assume scrub does this only when a read error has been
encountered. Does anyone think it would be a good option to write 100%
of the data back on request?

I am asking because I have ddrescue running on a hard drive that had
data written to it years ago and the data was never even looked at.
Then, some blocks started to go bad so I started the recovery and wow,
is it going slow. It does have some read errors, some pending sectors, and
some multizone error rate, whatever that is, but they are not increasing
at a steady rate, it will go a few days without them increasing. I suspect
this is merely some stale data that could have been prevented by something
like dd if=dev of=dev once a year.
Anyway some performance numbers, obviously not related to Btrfs:
I started this Nov 22nd with about 1 day of downtime.

$ ddrescue -n -a 10000 /dev/sdi4 opt.img opt.log

GNU ddrescue 1.16
Press Ctrl-C to interrupt
Initial status (read from logfile)
rescued:    44177 MB,  errsize:   9879 kB,  errors:     207
Current status
rescued:    55578 MB,  errsize:   9879 kB,  current rate:       30 B/s
    ipos:    58881 MB,   errors:     207,    average rate:     131 kB/s
    opos:    58881 MB,     time since last successful read:       0 s
Copying non-tried blocks...



=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   196   196   051    Pre-fail  Always       -       269625
   3 Spin_Up_Time            0x0003   177   174   021    Pre-fail  Always       -       6125
   4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       586
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
   7 Seek_Error_Rate         0x000e   200   200   051    Old_age   Always       -       0
   9 Power_On_Hours          0x0032   083   083   000    Old_age   Always       -       12753
  10 Spin_Retry_Count        0x0012   100   100   051    Old_age   Always       -       0
  11 Calibration_Retry_Count 0x0012   100   100   051    Old_age   Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       485
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       197
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Always       -       588
194 Temperature_Celsius     0x0022   115   085   000    Old_age   Always       -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0012   183   183   000    Old_age   Always       -       1439
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age   Offline      -       11
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       232
200 Multi_Zone_Error_Rate   0x0008   001   001   051    Old_age   Offline  FAILING_NOW 27189

