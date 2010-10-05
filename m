From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: find subvolume (used) size?
Date: Tue, 05 Oct 2010 13:26:36 +0200
Message-ID: <4CAB0B6C.3050908@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Since CoW / reflink does not seem to work between subvolumes (a bug or a 
feature?), is it somehow possible to get the subvolume (used) size?

There is a standard df tool, but it can be a lengthy process for 
filesystems with lots of files.


"btrfs filesystem df" only shows total size for the whole btrfs filesystem.


Say, I create subvolumes called public, office, staff and pack a lot of 
files there. Does btrfs somehow allows to get the current size of these 
subvolumes (other than using df tool to traverse all files and directories)?



-- 
Tomasz Chmielewski
http://wpkg.org
