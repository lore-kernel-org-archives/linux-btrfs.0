Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:41473 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaDBQ46 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 12:56:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140402164709.GI29256@twin.jikos.cz>
References: <CA+5PVA787+k0TVFUuo6PxNWMwffWDKixmt2C+E4_9szUJatYkw@mail.gmail.com>
	<20140402164709.GI29256@twin.jikos.cz>
Date: Wed, 2 Apr 2014 12:56:57 -0400
Message-ID: <CA+5PVA4G9NtixrwN3H+e2jmj=oLHZO2JfERqm70ama+zh_DUWw@mail.gmail.com>
Subject: Re: Btrfs lockdep with 3.15 merge window v3.14-751-g683b6c6f82a6
From: Josh Boyer <jwboyer@fedoraproject.org>
To: dsterba@suse.cz, Chris Mason <clm@fb.com>, jbacik@fb.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 2, 2014 at 12:47 PM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Apr 01, 2014 at 06:23:11PM -0400, Josh Boyer wrote:
>> Below is a lockdep spew I have on a local VM running Linus' tree as of
>> this afternoon.  The specific git commit is v3.14-751-g683b6c6f82a6.
>
>> [  295.349016]        CPU0                    CPU1
>> [  295.349016]        ----                    ----
>> [  295.349016]   lock(&found->groups_sem);
>> [  295.349016]                                local_irq_disable();
>> [  295.349016]                                lock(&delayed_node->mutex);
>> [  295.349016]                                lock(&found->groups_sem);
>> [  295.349016]   <Interrupt>
>> [  295.349016]     lock(&delayed_node->mutex);
>
> Fixed by https://patchwork.kernel.org/patch/3894781/

Thanks for the pointer!  I'll grab that and give it a shot on my VM.

josh
