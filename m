Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53016 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759517Ab3DIM1a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 08:27:30 -0400
Date: Tue, 9 Apr 2013 14:27:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Cc: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>
Subject: Re: btrfs-progs: re-add send-test
Message-ID: <20130409122726.GH18193@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <516069AC.7030900@redhat.com>
 <5163B718.8050500@jan-o-sch.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5163B718.8050500@jan-o-sch.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 09, 2013 at 08:37:12AM +0200, Jan Schmidt wrote:
> On 06.04.2013 20:30, Eric Sandeen wrote:
> > From: Mark Fasheh <mfasheh@suse.de>
> > 
> > btrfs-progs: re-add send-test
> > 
> > send-test.c links against libbtrfs and uses the send functionality provided
> > to decode and print a send stream to the console.
> 
> This looks pretty much like fardump from Arne's far repository:

AFAICS, send-test uses the NO_FILE_DATA mode, and the implementation
differes (it calls into btrfs_read_and_process_send_stream, unlike
fardump that dumps the attributes as it finds them), but the goal of the
utility seems to be the same.

> In my opinion, one of the next steps would be getting the logic used in
> btrfs receive into a generic far lib, which itself would link against
> libbtrfs to take the btrfs part from there. So, "btrfs receive" on the
> command line would become a stub calling something in the yet to create
> far lib, which itself would call hooks back to libbtrfs.

Sounds good in the long term.

> I have no plan ready how to build btrfs progs if we're doing such a
> shift, that would have to be sorted out.
> 
> My goal is to get everything that could be shared with other filesystems
> out of btrfs-progs into a far lib, and the send-test sent here
> definitely falls into that category; plus: it already exists outside
> btrfs-progs, unless I'm missing something.

I don't know if Mark has other plans with send-test or if it's a
debugging or development utility. Merging functinality with FAR will
take some time.

Are you fine with keeping send-test in btrfsprogs until then? It's not
built by default so nobody will probably rely on it so it could get
replaced by fardump eventually.


david
