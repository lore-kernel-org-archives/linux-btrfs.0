Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 50-193-208-193-static.hfc.comcastbusiness.net ([50.193.208.193]:52065
	"EHLO tetsuo.zabbo.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932357Ab2GCQeu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2012 12:34:50 -0400
Message-ID: <4FF31D41.8070907@zabbo.net>
Date: Tue, 03 Jul 2012 09:26:41 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>,
        =?ISO-8859-1?Q?Sw=E2mi_Petaramesh?= <swami@petaramesh.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: BTRFS fsck apparent errors
References: <4FF30B55.6060205@petaramesh.org> <20120703152208.GA28701@carfax.org.uk> <20120703155212.GG5326@twin.jikos.cz>
In-Reply-To: <20120703155212.GG5326@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/03/2012 08:52 AM, David Sterba wrote:
> On Tue, Jul 03, 2012 at 04:22:08PM +0100, Hugo Mills wrote:
>>     Correct, by default it just checks the filesystem. Just to be sure:
>> the filesystems in question weren't mounted, were they?
>
> fsck will refuse to run on a mounted filesystem, though in case of a
> read-only mount it might be useful during debugging, I'm using this
> patch
>
> --- a/btrfsck.c
> +++ b/btrfsck.c
> @@ -3474,6 +3474,7 @@ static struct option long_options[] = {
>          { "repair", 0, NULL, 0 },
>          { "init-csum-tree", 0, NULL, 0 },
>          { "init-extent-tree", 0, NULL, 0 },
> +       { "force", 0, NULL, 0 },

If we were to run with this, I think it should be called something other
than force.  fsck.ext* has trained people to think that 'forcing' a fsck
means doing a full repair pass even if the fs thinks that it was shut
down cleanly.

--read-only would be good if fsck was taught to not even try to write in
this mode.

- z
