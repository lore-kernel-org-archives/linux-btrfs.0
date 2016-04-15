Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:38789 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbcDOLTU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 Apr 2016 07:19:20 -0400
Received: by mail-ig0-f171.google.com with SMTP id ui10so19156472igc.1
        for <linux-btrfs@vger.kernel.org>; Fri, 15 Apr 2016 04:19:19 -0700 (PDT)
Subject: Re: RFE: btrfs subvolume list -t, include marker for snapshots, and
 whether they are ro
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtSUj0fcsH7AUREnm7KzdDZiL2pW9MpSkKiQBcV9-J9nXQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <5710CE23.3060107@gmail.com>
Date: Fri, 15 Apr 2016 07:18:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSUj0fcsH7AUREnm7KzdDZiL2pW9MpSkKiQBcV9-J9nXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-04-14 21:55, Chris Murphy wrote:
> Hi,
>
> I'm realizing instead of doing 'btrfs subvolume -t' and then 'btrfs
> subvolume -tr' and comparing, it would be better if -t just had a
> column for whether a subvolume is ro. And maybe it's useful to know if
> a subvolume is a snapshot or not (?). I'm not super picky about the
> last one. But being able to see if it's ro or not is a nice to have.
If you're just wanting info about one subvolume, just use 'subvol show'. 
  As far as 'subvol list', that was mentioned in discussion on github of 
future changes for btrfs-progs (although I don't think that's gone 
anywhere).

Checking if something is a snapshot is easy though, do 'btrfs subvolume 
show -qt', if the Parent UUID column is a -, it's a regular subvolume, 
if not, it was created as a snapshot.
