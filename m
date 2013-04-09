Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from brockman.in8.de ([85.214.220.56]:52540 "EHLO mail.in8.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935102Ab3DIRJN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Apr 2013 13:09:13 -0400
Message-ID: <51644B37.8060904@jan-o-sch.net>
Date: Tue, 09 Apr 2013 19:09:11 +0200
From: Jan Schmidt <list.btrfs@jan-o-sch.net>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: Eric Sandeen <sandeen@redhat.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>
Subject: Re: btrfs-progs: re-add send-test
References: <516069AC.7030900@redhat.com> <5163B718.8050500@jan-o-sch.net> <20130409122726.GH18193@twin.jikos.cz>
In-Reply-To: <20130409122726.GH18193@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09.04.2013 14:27, David Sterba wrote:
> On Tue, Apr 09, 2013 at 08:37:12AM +0200, Jan Schmidt wrote:
>> > On 06.04.2013 20:30, Eric Sandeen wrote:
>>> > > From: Mark Fasheh <mfasheh@suse.de>
>>> > > 
>>> > > btrfs-progs: re-add send-test
>>> > > 
>>> > > send-test.c links against libbtrfs and uses the send functionality provided
>>> > > to decode and print a send stream to the console.
>> > 
>> > This looks pretty much like fardump from Arne's far repository:
> AFAICS, send-test uses the NO_FILE_DATA mode, and the implementation
> differes (it calls into btrfs_read_and_process_send_stream, unlike
> fardump that dumps the attributes as it finds them), but the goal of the
> utility seems to be the same.

Good point, we will have to add something like NO_FILE_DATA to the far
lib (and probably even the zfs sender) as well.

> [snip]
>
> Are you fine with keeping send-test in btrfsprogs until then? It's not
> built by default so nobody will probably rely on it so it could get
> replaced by fardump eventually.

I'm absolutely fine with that. To make really sure we're not breaking
anything as soon as we organize things differently, I suggest prepending

+	printf("Output format is known to be changed. Do not rely on it. You have been warned.\n");

or the like, but I don't insist on it :-)

-Jan
