Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-35.italiaonline.it ([212.48.25.163]:37413 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753198AbbF0Lio (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 27 Jun 2015 07:38:44 -0400
Message-ID: <558E8B3D.5070906@inwind.it>
Date: Sat, 27 Jun 2015 13:38:37 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        Omar Sandoval <osandov@fb.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH 0/2] btrfs device remove alias
References: <cover.1435161735.git.osandov@fb.com> <558CA6A0.20401@oracle.com> <20150626133323.GS726@twin.jikos.cz>
In-Reply-To: <20150626133323.GS726@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-06-26 15:33, David Sterba wrote:
> On Fri, Jun 26, 2015 at 09:10:56AM +0800, Anand Jain wrote:
>> while on this. its also good idea to create alias for
>>
>>    btrfs replace start -> btrfs device replace.
> 
> This was asked for back then, and briefly discussed on irc (11/2012).
> The preference was not to do too much typing, although the command
> hierarchy would become less structured and can cause some trouble when
> looking for docs.
> 
> I'm slightly worried about adding more aliases as it can cause confusion
> when writing documentaiton and recommending how to do things.  But I
> understand the motivations to make the interface more consistent or
> convenient to use.
> 
> In this case it's moving replace to the expected place. I'm not against
> it but more feedback would help.

I agree that btrfs device replace makes sense. The point is what about btrfs
 replace status and cancel. 

We could add these subcommand to device too, also because it makes sense to
extend these to support the remove/delete command. I am not suggesting to
do that now, but our decision has to take in account also these (possible ?)
further alias.

Goffredo



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
