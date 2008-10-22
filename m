From: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 13:46:34 +0200
Message-ID: <20081022134634.573aa57f.skraw@ithnet.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	<1224597580.27474.93.camel@think.oraclecorp.com>
	<20081021182710.a12f4914.skraw@ithnet.com>
	<87iqrlevf5.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <87iqrlevf5.fsf@basil.nowhere.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 21 Oct 2008 18:59:26 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Stephan von Krawczynski <skraw@ithnet.com> writes:
> >
> > Yes, we hear and say that all the time, name one linux fs doing it, please.
> 
> ext[234] support it to some extent. It has some limitations
> (especially when the files are large and you shouldn't do too much followon
> IO to prevent the data from being overwriten) and the user frontends are not
> very nice, but it it's there

Well, they must be pretty ugly, I really never heard of that. But really, it
is not very important, because extX is completely useless with TB-size disks
unless you feel good waiting hours for fsck (I did, and will never do again). 
_All_ customers we deployed ext3 urged us to go back to reiserfs3 ...

> -Andi

-- 
Regards,
Stephan
