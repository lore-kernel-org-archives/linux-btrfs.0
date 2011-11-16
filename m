From: Alexandre Oliva <oliva@lsd.ic.unicamp.br>
Subject: Re: Don't prevent removal of devices that break raid reqs
Date: Wed, 16 Nov 2011 01:21:40 -0200
Message-ID: <orty64pxa3.fsf@livre.localdomain>
References: <orvcqrpycf.fsf@livre.localdomain> <20111111022100.GD4435@shiny>
	<20111115093713.GB8597@zambezi.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111115093713.GB8597@zambezi.lan> (Ilya Dryomov's message of
	"Tue, 15 Nov 2011 11:37:13 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

On Nov 15, 2011, Ilya Dryomov <idryomov@gmail.com> wrote:

> On Thu, Nov 10, 2011 at 09:21:00PM -0500, Chris Mason wrote:
>> On Thu, Nov 10, 2011 at 05:32:48PM -0200, Alexandre Oliva wrote:
>> > Instead of preventing the removal of devices that would render existing
>> > raid10 or raid1 impossible, warn but go ahead with it; the rebalancing
>> > code is smart enough to use different block group types.
>> > 
>> > Should the refusal remain, so that we'd only proceed with a
>> > newly-introduced --force option or so?
>> 
>> Hmm, going to three devices on raid10 doesn't turn it into
>> raid1.  It turns it into a degraded raid10.

Oops.  I *knew* there was some case I had failed to test.  I thought I'd
the two relevant cases, but I must have tested only raid0 to single and
raid1 to dup.

> If user wants to downgrade his FS he
> can do that explicitly with restriper.

Didn't I just read in another thread that restriper won't let one switch
from raid1 to dup without going through single in between?  That's what
I actually needed to do that drove me to write the patch a while ago
after accidentally adding a device to the wrong filesystem, and if
restriper won't do it without going through a riskier stage in between
(metadata loss due to e.g. a bad block), I wish it was improved so that
this is possible.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
