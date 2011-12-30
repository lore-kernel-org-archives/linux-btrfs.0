From: =?us-ascii?Q?Jaromir=20Zdrazil?= <jaromir.zdrazil@email.cz>
Subject: =?us-ascii?Q?Who=20way=20mirror=20in=20BRTFS?=
Date: Fri, 30 Dec 2011 12:41:16 +0100 (CET)
Message-ID: <135478.27027.62193-16529-1080748879-1325245275@email.cz>
Reply-To: jaromir.zdrazil@email.cz
Mime-Version: 1.0
Content-Type: text/plain;	charset="us-ascii"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,

   sorry to borther you, but I need some info and you are propably the best one to answer.

   I am planing now a new backup system (servers) for a medical company. My idea is to have a dedicated backup server in each building and wia two way mirror mirror it to another server in diff building (bacause of security) through fs. ZFS is capable, but i would like to stick to a Linux.
   As I understand, there is some work done in two way mirror in brtfs (which seems to me as best solustion for that under linux) and you are the one working on that.

   My Qs are:
- do you know any better fs for this purpose, other than brtfs under Linux?
- What is the implementation of two way mirror in brtfs, and when do you expect to have it done to a degree so I can try it? Tt does not have to work now, but it should work next year ;O)

I have 20years experience in linux, and if I do not have to debug anything, I am more less happy ;O)

Thank you very much! Jaromir
