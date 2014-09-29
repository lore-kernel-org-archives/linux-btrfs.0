Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f45.google.com ([209.85.215.45]:47222 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaI2R31 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 29 Sep 2014 13:29:27 -0400
Received: by mail-la0-f45.google.com with SMTP id q1so6801818lam.4
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Sep 2014 10:29:25 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20140929154301.GP26729@merlins.org>
References: <20140927201941.GL26729@merlins.org>
	<CAL3q7H7iBBQPnN6dXsXi62TT2qV-Z8JnW3YFAjiPZ6BdZMOt3w@mail.gmail.com>
	<20140929154301.GP26729@merlins.org>
Date: Mon, 29 Sep 2014 18:29:25 +0100
Message-ID: <CAL3q7H4KCTZ0RAggWc7TwaPXirYieejCJbx4Y9syeNS-AnTkwg@mail.gmail.com>
Subject: Re: 3.16.3 btrfs receive dies with rename o4736059-335172-0 ->
 merlin/RC/OSD failed. Directory not empty machine
From: Filipe David Manana <fdmanana@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Filipe David Borba Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 29, 2014 at 4:43 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Mon, Sep 29, 2014 at 01:10:37PM +0100, Filipe David Manana wrote:
>> > Is there a patch you'd like me to try, or should I just work around the
>> > problem by deleting all these directories and recreating in 2 steps to
>> > get around the bug?
>>
>> For the moment you'll have to use the workaround.
>>
>> I have a hunch about what it might be, but to confirm it (or help if
>> it's wrong/incomplete) please send me the full output of the following
>> commands:
>>
>> - tree -d --inodes, at the root of the parent snapshot
>> - tree -d --inodes, at the root of the second snapshot
>> - btrfs receive -vv --max-errors=0 .... (needs btrfs-progs 3.16.x I believe)
>>
>> And I'll try to figure it out sometime this week.
>
> Thanks.
>
> Here's the relevant stripped output:
> Before:
> └── [    257]  merlin
>     ├── [1294378]  RC
>     │   ├── [3490376]  Docs
>     │   ├── [1651282]  notes -> /home/merlin/public_html/notes/rc
>     │   ├── [2682102]  OSD
>     │   │   ├── [3964804]  old
>     │   │   └── [3964832]  Source
>     │   │       ├── [3964833]  Copter
>     │   │       └── [3964835]  Plane
>
> After:
> └── [    257]  merlin
>     ├── [1294378]  RC
>     │   ├── [3490376]  Docs
>     │   ├── [1651282]  notes -> /home/merlin/public_html/notes/rc
>     │   ├── [4736059]  OSD
>     │   │   ├── [3964804]  OSD-2.0
>     │   │   ├── [4736027]  OSD-Copter 789
>     │   │   └── [2682102]  OSD-Plane 788
>     │   │       └── [3964832]  Source
>     │   │           ├── [3964833]  Copter
>     │   │           └── [3964835]  Plane

It's better than before, but I still need the *full* output from the
tree commands and receive -vv --max-errors=0.

thanks Marc

>
> Log (stripped):
> Create a readonly snapshot of 'home' in './home_ro.20140929_08:19:16'
> At subvol home_ro.20140929_08:19:16
> At snapshot home_ro.20140929_08:19:16
> receiving snapshot home_ro.20140929_08:19:16 uuid=807e5a76-8a80-9c44-9864-426dc8283523, ctransid=343443 parent_uuid=4c7431e0-106f-d243-b317-078e393e091c, parent_ctransid=335144
> truncate merlin/RC/OSD/old/config.xml size=109
> utimes merlin/RC/OSD/old/config.xml
> unlink merlin/downloads/CT Tool for MinimOSD Extra 2.3.2.0 Pre Release r727.zip
> utimes merlin/RC/OSD
> truncate merlin/RC/OSD/config.xml size=274
> utimes merlin/RC/OSD/config.xml
> link o4736027-335149-0/octocopter1.osd -> merlin/RC/OSD/octocopter1.osd
> unlink merlin/RC/OSD/octocopter1.osd
> utimes merlin/RC/OSD
> unlink merlin/downloads/MinimOSDExtra_Copter_Prerelease_2.4_r794.hex
> unlink merlin/downloads/MinimOSDExtra_Copter_Prerelease_2.4_r789.zip
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
> chown merlin/RC/OSD - uid=500, gid=500
> chmod merlin/RC/OSD - mode=0755
> rename merlin/RC/OSD -> merlin/RC/OSD/OSD-Plane 788
> ERROR: rename merlin/RC/OSD -> merlin/RC/OSD/OSD-Plane 788 failed. Invalid argument
> utimes merlin/RC/OSD/OSD-Plane 788
> ERROR: utimes merlin/RC/OSD/OSD-Plane 788 failed. No such file or directory
> utimes merlin/RC/OSD
> rename merlin/RC/OSD/OSD-Plane 788/old -> merlin/RC/OSD/OSD-2.0
> ERROR: rename merlin/RC/OSD/OSD-Plane 788/old -> merlin/RC/OSD/OSD-2.0 failed. No such file or directory
> utimes merlin/RC/OSD/OSD-2.0
> ERROR: utimes merlin/RC/OSD/OSD-2.0 failed. No such file or directory
> utimes merlin/RC/OSD/OSD-Plane 788
> ERROR: utimes merlin/RC/OSD/OSD-Plane 788 failed. No such file or directory
> utimes merlin/RC/OSD
> utimes merlin/RC/OSD
> rename o4736194-335193-0 -> merlin/RC/OSD/OSD-Copter 789/octocopter2.osd
> ERROR: rename o4736194-335193-0 -> merlin/RC/OSD/OSD-Copter 789/octocopter2.osd failed. No such file or directory
> utimes merlin/RC/OSD/OSD-Copter 789
> ERROR: utimes merlin/RC/OSD/OSD-Copter 789 failed. No such file or directory
> ERROR: open /mnt/btrfs_pool2//home_ro.20140929_08:19:16/merlin/RC/OSD/OSD-Copter 789/octocopter2.osd failed. No such file or directory
> truncate merlin/RC/OSD/OSD-Copter 789/octocopter2.osd size=1713
> ERROR: truncate merlin/RC/OSD/OSD-Copter 789/octocopter2.osd failed. No such file or directory
> chown merlin/RC/OSD/OSD-Copter 789/octocopter2.osd - uid=500, gid=500
> ERROR: chown merlin/RC/OSD/OSD-Copter 789/octocopter2.osd failed. No such file or directory
> chmod merlin/RC/OSD/OSD-Copter 789/octocopter2.osd - mode=0644
> ERROR: chmod merlin/RC/OSD/OSD-Copter 789/octocopter2.osd failed. No such file or directory
> utimes merlin/RC/OSD/OSD-Copter 789/octocopter2.osd
> ERROR: utimes merlin/RC/OSD/OSD-Copter 789/octocopter2.osd failed. No such file or directory
>
> ABORT: btrfs send -p /mnt/btrfs_pool1/home_ro.20140927_09:00:00 home_ro.20140929_08:19:16 |  btrfs receive /mnt/btrfs_pool2// failed
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
