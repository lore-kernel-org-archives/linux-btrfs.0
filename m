Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54377 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751052AbaF0QiO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Jun 2014 12:38:14 -0400
Message-ID: <53AD9DF2.9030200@redhat.com>
Date: Fri, 27 Jun 2014 11:38:10 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: add supported attr flags to btrfs(5)
References: <53AC84C9.2080106@redhat.com> <20140627134257.GE1553@twin.jikos.cz> <53AD860A.8090804@redhat.com> <20140627153017.GF1553@suse.cz> <53AD8F96.4060401@redhat.com> <20140627161025.GG1553@suse.cz>
In-Reply-To: <20140627161025.GG1553@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 6/27/14, 11:10 AM, David Sterba wrote:
> On Fri, Jun 27, 2014 at 10:36:54AM -0500, Eric Sandeen wrote:

...

>> btrfs tries to handle a flag value which is identical to the
>> 'X' flag value, which lsattr/chattr says is readonly...
> 
> I'm looking at it from the kernel side, ie what's its meaning of the
> flag. The chattr tool still lives under the hood of e2fsprogs, but
> the ioctl interface is inherited to other filesystems (stating the
> obvious). e2fsprogs/chattr can decide to implement other meaning or new
> bits more or less freely (eg. there's the new 'N' flag for inlined files
> that I discovered just today while exploring the 'X' flag).

Yes, the interface originated w/ extN, but has clearly spread to other
filesystems, and spread like a weed.  ;)  It's still the de facto
interface, but looking through other filesystems, it's a bit of a disaster.
(filesystems specifying inheritance of flags they ignore, for example).

> There was a discussion at fsdevel about extending the interface or
> reworking it completely, I don't know if there's an outcome.
> 
> From the btrfs side, we have the object properties that make a nice
> interface for accessing the file attributes in parallel with the chattr
> tool. The interface is currently underused so it's not possible to
> manipulate the flags yet.

or test the code, despite it being merged.  \o/  oh well...

> I'd rather move the efforts to finalize this interface than adding
> single bits of the SETFLAGS ioctl and further extensions of the
> chattr/lsattr tools.

ok.  In any case, back to the original patch:  Your changes look fine.
'X' can't be set, so leave it out.  Sorry about the 'd' vs 'D' - and I
like the new formatting.  Feel free to make those changes.

(only nitpick: is 'X' ever reported by lsattr on btrfs?  If so,
it could/should still be included)

((and a side note: I tried to change the text of the manpage to
be "btrfs" not "btrfs-mount" but that somehow broke the build, and
I didn't dig a lot further)) 

-Eric

