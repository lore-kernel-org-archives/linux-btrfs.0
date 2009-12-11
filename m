From: schaarsc@gmx.de
Subject: Idea (laptop support) for Project_ideas
Date: Fri, 11 Dec 2009 15:15:41 +0100
Message-ID: <200912111515.41768.schaarsc@gmx.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I've seen a lot of interesting ideas on your wiki page.
http://btrfs.wiki.kernel.org/index.php/Project_ideas

I'd like to see one more:
combining some features (snapshot, Incremental backups, Hybrid Storage, NFS 
support ) could lead to a file system for Laptops with disconnected mode 
support.

For example: laptop user with home on file server or shared project workspace 
on file server.
snapshot could be used to make local copy (cache for NFS mount)
in connected mode hybird storage could combine local cache with remote file 
server, reading from cache and propagateing changes to fileserver.
in disconnected mode user works with data in cache.
incremental backup could be used for synch after reconnect.

this would introduce a whole set of new problems, network latency, conflict 
resolution, security, etc. but it's an idea on how to expand btrfs usage to 
the mobile world.

Regards
Christian
