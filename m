Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:53388 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbaBJVwr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 16:52:47 -0500
Received: by mail-la0-f48.google.com with SMTP id mc6so5176970lab.21
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 13:52:46 -0800 (PST)
Received: from melforce.localnet (melforce.xtsubasa.org. [2a02:578:5002:8062::2])
        by mx.google.com with ESMTPSA id y2sm24192773lal.10.2014.02.10.13.52.44
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 10 Feb 2014 13:52:45 -0800 (PST)
From: Pavel Volkov <negaipub@gmail.com>
To: linux-btrfs@vger.kernel.org
Subject: Re: Error: could not do orphan cleanup -22
Date: Tue, 11 Feb 2014 01:52:42 +0400
Message-ID: <1726046.kZYFW4zOS4@melforce>
In-Reply-To: <52F94104.4030201@fb.com>
References: <2047669.QmpNhlvBGM@melforce> <2047838.eX9UXPvc1f@melforce> <52F94104.4030201@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Monday 10 February 2014 16:13:40 Josef Bacik wrote:
> Build a kernel with this patch applied
> 
> http://ur1.ca/glslj
> 
> and re-run the mount and when it fails attach dmesg to this email.  Thanks,

I don't see these new messages nor the previous "-22" messages in dmesg now.
Only the access problem:

melforce mnt # ls btr2
home  vap-snap1  vap-snap2  var

melforce mnt # ls btr2/var-snap1
ls: cannot access btr2/var-snap1: No such file or directory

melforce mnt # ls btr2/var
cache  db  empty  lib  lock  log  mail  nmbd  run  spool  src  tmp  www
