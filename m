Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:38030 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaI0UTx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Sep 2014 16:19:53 -0400
Date: Sat, 27 Sep 2014 13:19:41 -0700
From: Marc MERLIN <marc@merlins.org>
To: linux-btrfs@vger.kernel.org, fdmanana@suse.com
Message-ID: <20140927201941.GL26729@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Subject: 3.16.3 btrfs receive dies with rename o4736059-335172-0 ->
 merlin/RC/OSD failed. Directory not empty machine
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Filipe and others,

After I moved directories around, and since then my hourly 
btrfs backup is failing.

Does this output help?

Is there a patch you'd like me to try, or should I just work around the
problem by deleting all these directories and recreating in 2 steps to
get around the bug?

Thanks,
Marc

grep OSD in btrfs receive -v -v -v output gives:
truncate merlin/RC/OSD/old/config.xml size=109
utimes merlin/RC/OSD/old/config.xml
utimes merlin/RC/OSD
truncate merlin/RC/OSD/config.xml size=274
utimes merlin/RC/OSD/config.xml
link o4736027-335149-0/octocopter1.osd -> merlin/RC/OSD/octocopter1.osd
unlink merlin/RC/OSD/octocopter1.osd
utimes merlin/RC/OSD
rename o4736027-335149-0 -> o4736059-335172-0/OSD-Copter 789
chown o4736059-335172-0/OSD-Copter 789 - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789 - mode=0755
utimes o4736059-335172-0/OSD-Copter 789
rename o4736031-335150-0 -> o4736059-335172-0/OSD-Copter 789/ArduCam_logo.jpg
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/ArduCam_logo.jpg size=18721
chown o4736059-335172-0/OSD-Copter 789/ArduCam_logo.jpg - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/ArduCam_logo.jpg - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/ArduCam_logo.jpg
rename o4736032-335150-0 -> o4736059-335172-0/OSD-Copter 789/config.xml
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/config.xml size=274
chown o4736059-335172-0/OSD-Copter 789/config.xml - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/config.xml - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/config.xml
rename o4736033-335150-0 -> o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.0.mcm
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.0.mcm size=163847
chown o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.0.mcm - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.0.mcm - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.0.mcm
rename o4736034-335150-0 -> o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.1.mcm
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.1.mcm size=163847
chown o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.1.mcm - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.1.mcm - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/MinimOSD_2.4.0.1.mcm
rename o4736035-335150-0 -> o4736059-335172-0/OSD-Copter 789/MinimOSD-Extra_Copter_Pre-release_2.4_r789.hex
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/MinimOSD-Extra_Copter_Pre-release_2.4_r789.hex size=82216
chown o4736059-335172-0/OSD-Copter 789/MinimOSD-Extra_Copter_Pre-release_2.4_r789.hex - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/MinimOSD-Extra_Copter_Pre-release_2.4_r789.hex - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/MinimOSD-Extra_Copter_Pre-release_2.4_r789.hex
rename o4736036-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Config.application
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/OSD_Config.application size=1631
chown o4736059-335172-0/OSD-Copter 789/OSD_Config.application - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/OSD_Config.application - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/OSD_Config.application
rename o4736037-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Config.exe
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/OSD_Config.exe size=215040
chown o4736059-335172-0/OSD-Copter 789/OSD_Config.exe - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/OSD_Config.exe - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/OSD_Config.exe
rename o4736038-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.config
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.config size=117
chown o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.config - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.config - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.config
rename o4736039-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.manifest
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.manifest size=6218
chown o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.manifest - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.manifest - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/OSD_Config.exe.manifest
rename o4736040-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Config.pdb
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/OSD_Config.pdb size=196096
chown o4736059-335172-0/OSD-Copter 789/OSD_Config.pdb - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/OSD_Config.pdb - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/OSD_Config.pdb
rename o4736041-335150-0 -> o4736059-335172-0/OSD-Copter 789/OSD_Panels.ino
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/OSD_Panels.ino size=44250
chown o4736059-335172-0/OSD-Copter 789/OSD_Panels.ino - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/OSD_Panels.ino - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/OSD_Panels.ino
rename o4736042-335150-0 -> o4736059-335172-0/OSD-Copter 789/vlcsnap-2012-01-28-07h46m04s95.png
utimes o4736059-335172-0/OSD-Copter 789
truncate o4736059-335172-0/OSD-Copter 789/vlcsnap-2012-01-28-07h46m04s95.png size=281948
chown o4736059-335172-0/OSD-Copter 789/vlcsnap-2012-01-28-07h46m04s95.png - uid=500, gid=500
chmod o4736059-335172-0/OSD-Copter 789/vlcsnap-2012-01-28-07h46m04s95.png - mode=0644
utimes o4736059-335172-0/OSD-Copter 789/vlcsnap-2012-01-28-07h46m04s95.png
rename o4736059-335172-0 -> merlin/RC/OSD
ERROR: rename o4736059-335172-0 -> merlin/RC/OSD failed. Directory not empty


-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
