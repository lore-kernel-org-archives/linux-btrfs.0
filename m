Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898AbaFLOjN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 10:39:13 -0400
Message-ID: <5399BB92.2070205@redhat.com>
Date: Thu, 12 Jun 2014 09:39:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH V2] btrfs-progs: add mount options to btrfs-mount.5
References: <5398D475.4070309@redhat.com> <5398D4DF.9080508@redhat.com> <20140612105151.GN1903@twin.jikos.cz>
In-Reply-To: <20140612105151.GN1903@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/12/14, 5:51 AM, David Sterba wrote:
> On Wed, Jun 11, 2014 at 05:14:55PM -0500, Eric Sandeen wrote:
>> This is a straight cut and paste from the util-linux
>> mount manpage into btrfs-mount.5
>>
>> It's pretty much impossible for util-linux to keep up
>> with every filesystem out there, and Karel has more than
>> once expressed a wish that mount options move into fs-specific
>> manpages.
>>
>> So, here we go.
>>
>> The way btrfs asciidoc is generated, there's not a trivial
>> way to have both btrfs(5) and btrfs(8) so I named it btrfs-mount(5)
>> for now.  A bit ick and I'm open to suggestions.
> 
> So what if the mount options are generated from btrfs-mount.txt but
> installed under btrfs.5.gz name? If there are more section 5 manpages we
> can make it more generic but for now hardcoding btrfs-mount.* ->
> btrfs.5. sounds ok to me.

Yeah, that seemed like kind of nasty hard-coding, but I suppose it works
for now.  I wanted to make it more generic, I didn't have a better idea..

-Eric

