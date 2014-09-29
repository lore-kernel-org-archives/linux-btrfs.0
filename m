Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:45593 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431AbaI2MKj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 08:10:39 -0400
Received: by mail-lb0-f170.google.com with SMTP id n15so6063426lbi.15
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Sep 2014 05:10:37 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140927201941.GL26729@merlins.org>
References: <20140927201941.GL26729@merlins.org>
Date: Mon, 29 Sep 2014 13:10:37 +0100
Message-ID: <CAL3q7H7iBBQPnN6dXsXi62TT2qV-Z8JnW3YFAjiPZ6BdZMOt3w@mail.gmail.com>
Subject: Re: 3.16.3 btrfs receive dies with rename o4736059-335172-0 ->
 merlin/RC/OSD failed. Directory not empty machine
From: Filipe David Manana <fdmanana@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 27, 2014 at 9:19 PM, Marc MERLIN <marc@merlins.org> wrote:
> Hi Filipe and others,
>
> After I moved directories around, and since then my hourly
> btrfs backup is failing.
>
> Does this output help?

Partially.

>
> Is there a patch you'd like me to try, or should I just work around the
> problem by deleting all these directories and recreating in 2 steps to
> get around the bug?

For the moment you'll have to use the workaround.

I have a hunch about what it might be, but to confirm it (or help if
it's wrong/incomplete) please send me the full output of the following
commands:

- tree -d --inodes, at the root of the parent snapshot
- tree -d --inodes, at the root of the second snapshot
- btrfs receive -vv --max-errors=0 .... (needs btrfs-progs 3.16.x I believe)

And I'll try to figure it out sometime this week.

thanks

>
> Thanks,
> Marc
>
> grep OSD in btrfs receive -v -v -v output gives:
> truncate merlin/RC/OSD/old/config.xml size=109
> utimes merlin/RC/OSD/old/config.xml
> utimes merlin/RC/OSD
> truncate merlin/RC/OSD/config.xml size=274
> utimes merlin/RC/OSD/config.xml
> link o4736027-335149-0/octocopter1.osd -> merlin/RC/OSD/octocopter1.osd
> unlink merlin/RC/OSD/octocopter1.osd
> utimes merlin/RC/OSD
> rename o4736027-335149-0 -> o4736059-335172-0/OSD-Copter 789
> chown o4736059-335172-0/OSD-Copter 789 - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789 - mode=0755
> utimes o4736059-335172-0/OSD-Copter 789
> rename o4736031-335150-0 -> o4736059-335172-0/OSD-Copter 789/ArduCam_logo.jpg
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/ArduCam_logo.jpg size=18721
> chown o4736059-335172-0/OSD-Copter 789/ArduCam_logo.jpg - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/ArduCam_logo.jpg - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/ArduCam_logo.jpg
> rename o4736032-335150-0 -> o4736059-335172-0/OSD-Copter 789/config.xml
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/config.xml size=274
> chown o4736059-335172-0/OSD-Copter 789/config.xml - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/config.xml - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/config.xml
> rename o4736033-335150-0 -> o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.0.mcm
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.0.mcm size=163847
> chown o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.0.mcm - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.0.mcm - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.0.mcm
> rename o4736034-335150-0 -> o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.1.mcm
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.1.mcm size=163847
> chown o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.1.mcm - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.1.mcm - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.1.mcm
> rename o4736035-335150-0 -> o4736059-335172-0/OSD-Copter 789/MinimOSD-Extra_Copter_Pre-release_2.4_r789.hex
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/MinimOSD-Extra_Copter_Pre-release_2.4_r789.hex size=82216
> chown o4736059-335172-0/OSD-Copter 789/MinimOSD-Extra_Copter_Pre-release_2.4_r789.hex - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/MinimOSD-Extra_Copter_Pre-release_2.4_r789.hex - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/MinimOSD-Extra_Copter_Pre-release_2.4_r789.hex
> rename o4736036-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Config.application
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/OSD_Config.application size=1631
> chown o4736059-335172-0/OSD-Copter 789/OSD_Config.application - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/OSD_Config.application - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/OSD_Config.application
> rename o4736037-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Config.exe
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/OSD_Config.exe size=215040
> chown o4736059-335172-0/OSD-Copter 789/OSD_Config.exe - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/OSD_Config.exe - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/OSD_Config.exe
> rename o4736038-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.config
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.config size=117
> chown o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.config - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.config - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.config
> rename o4736039-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.manifest
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.manifest size=6218
> chown o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.manifest - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.manifest - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.manifest
> rename o4736040-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Config.pdb
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/OSD_Config.pdb size=196096
> chown o4736059-335172-0/OSD-Copter 789/OSD_Config.pdb - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/OSD_Config.pdb - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/OSD_Config.pdb
> rename o4736041-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Panels.ino
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/OSD_Panels.ino size=44250
> chown o4736059-335172-0/OSD-Copter 789/OSD_Panels.ino - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/OSD_Panels.ino - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/OSD_Panels.ino
> rename o4736042-335150-0 -> o4736059-335172-0/OSD-Copter 789/vlcsnap-2012-01-28-07h46m04s95.png
> utimes o4736059-335172-0/OSD-Copter 789
> truncate o4736059-335172-0/OSD-Copter 789/vlcsnap-2012-01-28-07h46m04s95.png size=281948
> chown o4736059-335172-0/OSD-Copter 789/vlcsnap-2012-01-28-07h46m04s95.png - uid=500, gid=500
> chmod o4736059-335172-0/OSD-Copter 789/vlcsnap-2012-01-28-07h46m04s95.png - mode=0644
> utimes o4736059-335172-0/OSD-Copter 789/vlcsnap-2012-01-28-07h46m04s95.png
> rename o4736059-335172-0 -> merlin/RC/OSD
> ERROR: rename o4736059-335172-0 -> merlin/RC/OSD failed. Directory not empty
>
>
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
