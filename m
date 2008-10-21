From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 18:09:40 +0200
Message-ID: <87r66adj5n.fsf@basil.nowhere.org>
References: <20081021132322.271ad728.skraw@ithnet.com>
	<1224597580.27474.93.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan von Krawczynski <skraw@ithnet.com>,
	linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1224597580.27474.93.camel@think.oraclecorp.com> (Chris Mason's message of "Tue, 21 Oct 2008 09:59:40 -0400")
List-ID: <linux-btrfs.vger.kernel.org>

Chris Mason <chris.mason@oracle.com> writes:
>
> Started interactively?  I'm not entirely sure what that means, but in
> general when you ask the user a question about if/how to fix a
> corruption, they will have no idea what the correct answer is.

While that's true today, I'm not sure it has to be true always.
I always thought traditional fsck user interfaces were a
UI desaster and could be done much better with some simple tweaks. 

For example the fsck could present the user a list of files that ended
up in lost+found and let them examine them, instead of asking a lot of
useless questions. Or it could give a high level summary on how many
files in which part of the directory tree were corrupted. etc.etc.  Or
it could default to a high level mode that only gives such high level
information to the user.

So I don't think all corruptions could be done perfectly user
friendly, but at least the basic user friendliness in many
situations could be much improved.

-Andi


-- 
ak@linux.intel.com
