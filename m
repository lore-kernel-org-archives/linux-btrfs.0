From: devzero@web.de
Subject: btrfs filesystem freeze
Date: Sun, 21 Dec 2008 00:26:21 +0100
Message-ID: <550569572@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,=20

i was testing btrfs a little bit for stability and i think i have found=
 an issue.

during some heavy activity (multiple processes writing/reading to compr=
essed /btrfs at the same time), i did some snapshots in a loop (every 1=
0 seconds).

very soon, all filesystem activity stopped, i.e. i cannot read/write an=
yting from/to /btrfs anymore.
this happens with latest git-unstable with kernel 2.6.27
nothing in dmesg.=20

besides that, the system seems ok.

as the system is a vmware virtual machine, i did a snapshot of the syst=
em state, so we can always go back to this state.

if somebody want`s to analyse this, please tell me what to do.

regards
roland

ps:
btw,  is there some bugzilla/bugtracker for btrfs ?
____________________________________________________________________
Psssst! Schon vom neuen WEB.DE MultiMessenger geh=F6rt?=20
Der kann`s mit allen: http://www.produkte.web.de/messenger/?did=3D3123

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
