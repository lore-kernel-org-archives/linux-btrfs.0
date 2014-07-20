Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:3435 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750731AbaGTV2U (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 17:28:20 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by server (Postfix) with ESMTPSA id 5E5EF31313
	for <linux-btrfs@vger.kernel.org>; Sun, 20 Jul 2014 17:31:29 -0400 (EDT)
Message-ID: <53CC3478.8060503@shiftmail.org>
Date: Sun, 20 Jul 2014 23:28:24 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
References: <loom.20140720T102642-239@post.gmane.org>	<53CC1553.1020908@shiftmail.org> <20140721013609.6d99c399@natsu>
In-Reply-To: <20140721013609.6d99c399@natsu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 20/07/2014 21:36, Roman Mamedov wrote:
> On Sun, 20 Jul 2014 21:15:31 +0200
> Bob Marley <bobmarley@shiftmail.org> wrote:
>
>> Hi TM, are you doing other significant filesystem activity during this
>> rebuild, especially random accesses?
>> This can reduce performances a lot on HDDs.
>> E.g. if you were doing strenous multithreaded random writes in the
>> meanwhile, I could expect even less than 5MB/sec overall...
> I believe the problem here might be that a Btrfs rebuild *is* a strenuous
> random read (+ random-ish write) just by itself.
>
> Mdadm-based RAID would rebuild the array reading/writing disks in a completely
> linear manner, and it would finish an order of magnitude faster.

Now this explains a lot!
So they would just need to be sorted?
Sorting the files of a disk from lowest to highers block number prior to 
starting reconstruction seems feasible. Maybe not all of them together 
because they will be millions, but sorting them in chunks of 1000 files 
would still produce a very significant speedup!
