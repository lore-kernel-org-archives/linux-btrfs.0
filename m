Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758531AbcCVO0E (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 10:26:04 -0400
Date: Tue, 22 Mar 2016 15:25:34 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [RFC] Experimental btrfs encryption
Message-ID: <20160322142534.GA29764@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <56D79A5D.8070000@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56D79A5D.8070000@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 03, 2016 at 09:58:53AM +0800, Anand Jain wrote:
> . (I received couple of private emails on this, so looks like
>   I confused you and I'm writing again to clear the air on this).
> 
> > - Uses btrfs compression framework, so compression and then
> >    encryption is not possible. However yet evaluate if there
> >    are encryption algorithm which can compress as well.
> 
>   It should be compression and then encryption. I didn't mean to say
>   the other way around. However the btrfs encoding framework is
>   designed to handle any one of it in an elegant manner. So as of
>   user can configure either encryption OR compression by design.
> 
>   Further for users who are looking for both compression and encryption.
>   There are two ways that we could implement in future in the btrfs.
>   One enhance the btrfs encoding framework so that it can accommodate
>   two cascaded engines like compression and followed by encryption.
>   Or (mostly) a better approach would be to evaluate a single encoding
>   engine (algorithm) which can do both (compression and then encryption).
>   Which I think will be less invasive within btrfs, and probably be more
>   efficient.
> 
>   Hope I sound clearer now. Sorry if I wasn't before.
> 
> . I have put up a doc here:
> 
> https://docs.google.com/document/d/1fq9snDM_4ikn44UDNErjHqKXgZHukiJWS4Il3qVhm3M/edit?usp=sharing

It's just text, you could also send it as part of the patchset.

I'd very much like to see the crypto part covered in more detail, the
threat model, what's the right cipher to use and why. You've chosen
something that would demonstrate how it works, but eg. implementing the
AEAD mode would not be straightforward to add, while it would be a
significant difference against the current per-file encryption (we can
store per-block associated data cheaply). And there are certainly other
questions that I've missed.

The per-file encryption is on the way to the VFS layer, so we can
implement it in btrfs afterwards. Then the benefit of the proposed
patchset would be encrypted data on subvolume with snapshotting enabled.
That's probably something that people want and convers common usecases.
But we can go further, like full subvolume metadata encryption.
