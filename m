Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:44132 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932993AbaDBTfd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Apr 2014 15:35:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA4G9NtixrwN3H+e2jmj=oLHZO2JfERqm70ama+zh_DUWw@mail.gmail.com>
References: <CA+5PVA787+k0TVFUuo6PxNWMwffWDKixmt2C+E4_9szUJatYkw@mail.gmail.com>
	<20140402164709.GI29256@twin.jikos.cz>
	<CA+5PVA4G9NtixrwN3H+e2jmj=oLHZO2JfERqm70ama+zh_DUWw@mail.gmail.com>
Date: Wed, 2 Apr 2014 15:35:33 -0400
Message-ID: <CA+5PVA5H_03YmiC-atypY34QsNTN_3a6iTbFKhgihc-bCEWfvw@mail.gmail.com>
Subject: Re: Btrfs lockdep with 3.15 merge window v3.14-751-g683b6c6f82a6
From: Josh Boyer <jwboyer@fedoraproject.org>
To: dsterba@suse.cz
Cc: Chris Mason <clm@fb.com>, jbacik@fb.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 2, 2014 at 12:56 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Wed, Apr 2, 2014 at 12:47 PM, David Sterba <dsterba@suse.cz> wrote:
>> On Tue, Apr 01, 2014 at 06:23:11PM -0400, Josh Boyer wrote:
>>> Below is a lockdep spew I have on a local VM running Linus' tree as of
>>> this afternoon.  The specific git commit is v3.14-751-g683b6c6f82a6.
>>
>>> [  295.349016]        CPU0                    CPU1
>>> [  295.349016]        ----                    ----
>>> [  295.349016]   lock(&found->groups_sem);
>>> [  295.349016]                                local_irq_disable();
>>> [  295.349016]                                lock(&delayed_node->mutex);
>>> [  295.349016]                                lock(&found->groups_sem);
>>> [  295.349016]   <Interrupt>
>>> [  295.349016]     lock(&delayed_node->mutex);
>>
>> Fixed by https://patchwork.kernel.org/patch/3894781/
>
> Thanks for the pointer!  I'll grab that and give it a shot on my VM.

FWIW, this does seem to make the issue go away in my VM after testing
it for a while.  Thanks again for the pointer.

josh
