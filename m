Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f181.google.com ([209.85.128.181]:58232 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835Ab3LMQcw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Dec 2013 11:32:52 -0500
Received: by mail-ve0-f181.google.com with SMTP id oy12so1529396veb.40
        for <linux-btrfs@vger.kernel.org>; Fri, 13 Dec 2013 08:32:51 -0800 (PST)
Received: from [192.168.18.6] (cpe-174-106-200-117.ec.res.rr.com. [174.106.200.117])
        by mx.google.com with ESMTPSA id jw6sm3586625veb.3.2013.12.13.08.32.50
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Fri, 13 Dec 2013 08:32:50 -0800 (PST)
Message-ID: <52AB3673.1030607@czarc.net>
Date: Fri, 13 Dec 2013 11:31:47 -0500
From: Gene Czarcinski <gczarcinski@gmail.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: moving a subvol
References: <52AB30D4.7050408@czarc.net>
In-Reply-To: <52AB30D4.7050408@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/13/2013 11:07 AM, Gene Czarcinski wrote:
> I have hunted high and low for the information but, if it is out there,
> it is well hidden.
>
> What I want to do:  I want to relocate (move) a subvolume from one BTRFS
> volume to a different BTRFS volume.
>
> I have seen the writeup for incremental backup which takes a snapshot,
> and then using btrfs-send and btrfs-receive to create a copy on a
> different volume.  That works fine except the btrfs-receive set the new
> copy to be readonly.
>
> What I want to do is to use that new subvolume read/write.  The only way
> I have figured out to do this is to create another snapshot on the new
> volume which is NOT readonly.  I believe that means I need to keep both
> of these subvolumes around.

As soon as I sent this I believe I found the answer.

I was sort of right about creating the new read-write (NOT readonly) 
snapshot.  After it is created simply delete the one which was created 
by btrfs-receive.

I also found out that if you want to rename a subvolume, siple do it 
with "mv" like you would for a directory or a file.

OK folks, do I have it correct?

Gene

