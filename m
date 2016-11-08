Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:53884 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932177AbcKHRIU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Nov 2016 12:08:20 -0500
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: James Pharaoh <james@wellbehavedsoftware.com>
Cc: <linux-btrfs@vger.kernel.org>
Subject: Re: Announcing btrfs-dedupe
Date: Tue, 08 Nov 2016 18:08:16 +0100
MIME-Version: 1.0
Message-ID: <3f44f9ee-34f3-49b6-a041-1d417bb97c22@linuxsystems.it>
In-Reply-To: <23ae5e65-f6f1-3167-abeb-65b99aeca7cd@wellbehavedsoftware.com>
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
 <e9a425e6-0f1a-42ca-8200-1cad1193f048@linuxsystems.it>
 <7c1d65d8-3a95-1a1b-761f-8d765ed4e3e3@wellbehavedsoftware.com>
 <15418748-e831-4056-b399-39e4f50369de@linuxsystems.it>
 <23ae5e65-f6f1-3167-abeb-65b99aeca7cd@wellbehavedsoftware.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On martedì 8 novembre 2016 17:58:52 CET, James Pharaoh wrote:
> Yes, everything you have described here is something I intend 
> to create, and might as well include in the tool itself. I'll 
> add it to the roadmap ;-)

Sounds good, but I have yet another feature request which is even more 
interesting in my opinion.
If you ever used snapper you probably already found yourself in the 
poisition when you want to free some space and you actually can't, because 
the files you want to delete are already present in countless snapshots. 
Such a way you will have to delete the unwanted files from every snapshot, 
which is tedious task, even more difficult if you moved/renamed these 
files. What I actually do is exploiting duperemove's hashfile to grep for 
the checksum and obtain all the paths. Then I will have to switch the 
snapshots to rw, manually delete each file and finally switch them back to 
ro. A tool which automates these task would be awesome.

Niccolo'
