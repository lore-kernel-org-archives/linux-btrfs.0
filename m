From: 0bo0 <0.bugs.only.0@gmail.com>
Subject: Re: RAID-10 arrays built with btrfs & md report 2x difference in
	available size?
Date: Fri, 29 Jan 2010 14:13:22 -0800
Message-ID: <c67eed301001291413p51f248d6y7f3b2ac9ba02c447@mail.gmail.com>
References: <048D5581-1D1D-4F82-9FE3-0DBC1106EDB4@kupper.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Thomas Kupper <thomas@kupper.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <048D5581-1D1D-4F82-9FE3-0DBC1106EDB4@kupper.org>
List-ID: <linux-btrfs.vger.kernel.org>

> For me, it looks as if 2.03GB is way smaller than 931.51GB (2 << 931), no? Everything seems to be fine here.

gagh!  i "saw" TB, not GB.  8-/

> And regarding your original mail: it seems that df is still lying about the size of the btrfs fs, check http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg00758.html

it is, and reading -> "df is lying.  The total bytes in the FS include
all 4 drives.  I need to fix up the math for the total available
space.", it looks like its under control.  thx!
