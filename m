From: "dbz" <hwallenstone@gmx.de>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 16:35:55 +0200
Message-ID: <11a001c93453$7ec465a0$0a00a8c0@ALDI2>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

concerning this discussion, I'd like to put up some "requests" which 
strongly oppose to those brought up initially:

- if you run into an error in the fs structure or any IO error that prevents 
you from bringing the fs into a consistent state, please simply oops. If a 
user feels that availability is a main issue, he has to use a failover 
solution. In this case a fast and clean cut is desireable and no 
"pray-and-hope-mode" or "90%-mode". If avaliability is not the issue, it is 
in any case most important that data on the fs is safe. If you don't oops, 
you risk to pose further damage onto the filesystem and end up with a 
completely destroyed fs.

- if you get any IO error, please **don't** put up a number of retries or 
anything. If the device reports an error simply believe it. It is bad enough 
that many block drivers or controllers try to be smart and put up hundreds 
of retries. Adding further retries you only end up in wasting hours on 
useless retries. If availability is an issue, the user again has to put up a 
failover solution. Again, a clean cut is what is needed. The user has to 
make shure he uses appropiate configuration according to the importance of 
his data (mirroring on the fs and/or RAID, failover ...)

- if during mount something unexpected comes up and you can't be shure that 
the fs will work properly, please deny mounting and request a fsck. This can 
be easily handled by a start- or mount-script. During mount, take the time 
you need to ensure that the fs looks proper and safe to use. I'd rather now 
during boot that something is wrong than to run with a foul fs and end up 
with data loss or any other mixup later on.

- btrfs is no cluster fs, so there is no point of even thinking about it. If 
somebody feels he needs multiple writeable mounts of the same fs, please use 
a cluster fs. Of course, you have to live with the tradeoffs. Dreaming of a 
fs that uses something like witchcraft to do things like locking, quorums, 
cache synchronisation without penalty and, of course, without any 
configuration, is pointless.

In my opinon, the whole thing comes up from the idea of using cheap hardware 
and out-of-the-box configurations to keep promises of reliability and 
availability which are not realistic. There is a reason why there are more 
expensive HDDs, RAIDs, SANs with volume mirroring, multipathing and so on. 
Simply ignoring the fact that you have to use the proper tools to address 
specific problems and pray to the toothfairy to put a 
solve-all-my-problems-fs under your pillow is no solution. I'd rather have a 
solid fs with deterministic behavior and some state-of-the-art features.

Just my 2c.
(Gerald) 

