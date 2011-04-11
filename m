From: Ian Celing <iceling@rarcoa.com>
Subject: Error Handling Failed Devices
Date: Mon, 11 Apr 2011 10:22:04 -0500
Message-ID: <4DA31C9C.305@rarcoa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: Linux Development Mailing LIst <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I've been testing BTRFS and by-and-large the file system runs well. The 
most troubling issue I've run into so far is the inability to 
consistently recover from a failed device. If I simulate a failed device 
and try to balance media across the remaining drives I never get a 
consistent result.

#Sometimes I am able to delete the failed device and re-balance on the 
remaining drives but then the data doesn't balance properly and is 
apparently lost.

#Sometimes I am unable to delete the failed device and I am stuck with 
"Device Missing" message with unaccessible data on that drive.

#Sometimes I am able to delete the failed device. Add a new device. 
Re-balance, but the new array won't mount because of "wrong fs type, bad 
option, bad superblock on /dev/sdx".

I am using the latest kernel as of 2011-04-06. I read in earlier 
messages that this functionality isn't quite working yet as planned - 
That deleting devices really only serves to remove a 'working' disk for 
use elsewhere. I don't find a lot of feedback on this seemingly huge 
problem with the file system.


