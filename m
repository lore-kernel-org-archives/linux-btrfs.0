From: "Dipl.-Ing. Michael Niederle" <mniederle@gmx.at>
Subject: btrfs subvol find-modified
Date: Fri, 26 Mar 2010 19:51:47 +0100
Message-ID: <20100326195147.146db06e@simplux>
References: <20100326111807.24dcc2f0@simplux>
	<20100326132219.GF16453@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100326132219.GF16453@think>
List-ID: <linux-btrfs.vger.kernel.org>

I have added a command

btrfs subvolume find-modified <path> <last_gen>
	List the recently modified files and directories in a filesystem.

It's similar to find-new with the following differences:

* in addition to modified files it will also display modified directories

* it lists only the paths of the modified files and directories (no extent
  information)

Directories "." and ".." are filtered.

I will do extensive testing this weekend and then post the patch to this list
if wanted - if I'm able to master git until then ... ^^

Greetings, Michael
