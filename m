Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from azure.uno.uk.net ([95.172.254.11]:59680 "EHLO azure.uno.uk.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932433AbdKBAgG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 20:36:06 -0400
Received: from 82-132-213-109.dab.02.net ([82.132.213.109]:34056 helo=ty.sabi.co.UK)
        by azure.uno.uk.net with esmtpsa (TLSv1.2:DHE-RSA-AES128-SHA:128)
        (Exim 4.89)
        (envelope-from <postmaster@root.t00.sabi.co.uk>)
        id 1eA3UK-0007iR-E6
        for linux-btrfs@vger.kernel.org; Thu, 02 Nov 2017 00:36:04 +0000
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
        by ty.sabi.co.UK with esmtps(Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128)(Exim 4.82 3)
        id 1eA3U5-0008DC-S5
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Nov 2017 00:35:49 +0000
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="zd5ZURDapt"
Message-ID: <23034.26724.388278.859422@tree.ty.sabi.co.uk>
Date: Thu, 2 Nov 2017 00:35:48 +0000
To: Linux fs Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Need help with incremental backup strategy (snapshots, defragmentingt & performance)
In-Reply-To: <CAH=dxU6fJ1uJgY9ECFH8YpQkXQxc-qqDsuQZ=jd75HOE0nd2gA@mail.gmail.com>
References: <CAH=dxU5mGQ5ws11fFKC+X3F810MceMxNBwnCR=g=Rau9DLDRng@mail.gmail.com>
        <f17a1de9-8340-dae3-3b29-0e04440ca2a3@rqc.ru>
        <CAH=dxU7APYANHn3PjqepY9dr9F3RRhzE1OSgtar9tN-74haS9g@mail.gmail.com>
        <ca0bc340-25eb-bf80-82a1-fbb0e7ca1a44@rqc.ru>
        <CAH=dxU6fJ1uJgY9ECFH8YpQkXQxc-qqDsuQZ=jd75HOE0nd2gA@mail.gmail.com>
From: pg@btrfs.list.sabi.co.UK (Peter Grandi)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--zd5ZURDapt
Content-Type: text/plain; charset=us-ascii
Content-Description: message body text
Content-Transfer-Encoding: 7bit

[ ... ]

> The poor performance has existed from the beginning of using
> BTRFS + KDE + Firefox (almost 2 years ago), at a point when
> very few snapshots had yet been created. A comparison system
> running similar hardware as well as KDE + Firefox (and LVM +
> EXT4) did not have the performance problems. The difference
> has been consistent and significant.

That seems rather unlikely to depend on Btrfs, as I use Firefox
56 + KDE4 + Btrfs without issue, on somewhat old/small desktop
and laptop, and is implausible on general grounds. You haven't
provided so far any indication or quantification of your "speed"
problem (which may or not be a "performance" issue".

The things to look at usually at disk IO latency and rates, and
system CPU time while the bad speed is observable (user CPU time
is usually stuck at 100% on any JS based site as written earlier).
To look at IO latency and rates the #1 choice is always: 'iostat
-dk -zyx 1' and to look as system CPU (and user CPU) and other
interesting details I suggest using 'htop' with the attached
configuration file to write to "$HOME/.config/htop/htoprc".

> Sometimes I have used Snapper settings like this:

> TIMELINE_MIN_AGE="1800"
> TIMELINE_LIMIT_HOURLY="36"
> TIMELINE_LIMIT_DAILY="30"
> TIMELINE_LIMIT_MONTHLY="12"
> TIMELINE_LIMIT_YEARLY="10"

> However, I also have some computers set like this:

> TIMELINE_MIN_AGE="1800"
> TIMELINE_LIMIT_HOURLY="10"
> TIMELINE_LIMIT_DAILY="10"
> TIMELINE_LIMIT_WEEKLY="0"
> TIMELINE_LIMIT_MONTHLY="0"
> TIMELINE_LIMIT_YEARLY="0"

The first seems a bit "aspirational". IIRC "someone" confessed
that the SUSE default of 'TIMELINE_LIMIT_YEARLY="10"' was imposed
by external forces in the SUSE default configuration:
https://github.com/openSUSE/snapper/blob/master/data/default-config

https://wiki.archlinux.org/index.php/Snapper#Set_snapshot_limits
https://lists.opensuse.org/yast-devel/2014-05/msg00036.html


--zd5ZURDapt
Content-Type: text/plain; name="htoprc"
Content-Description: ~/.config/htop/htoprc
Content-Disposition: inline;
	filename="htoprc"
Content-Transfer-Encoding: 7bit

# Beware! This file is rewritten by htop when settings are changed in the interface.
# The parser is also very primitive, and not human-friendly.
fields=0 48 38 39 40 44 62 63 2 46 13 14 1 
sort_key=47
sort_direction=1
hide_threads=1
hide_kernel_threads=1
hide_userland_threads=1
shadow_other_users=0
show_thread_names=1
highlight_base_name=1
highlight_megabytes=1
highlight_threads=1
tree_view=0
header_margin=0
detailed_cpu_time=1
cpu_count_from_zero=1
update_process_names=0
color_scheme=0
delay=15
left_meters=AllCPUs Memory Swap 
left_meter_modes=1 1 1 
right_meters=Tasks LoadAverage Uptime 
right_meter_modes=2 2 2 

--zd5ZURDapt--
