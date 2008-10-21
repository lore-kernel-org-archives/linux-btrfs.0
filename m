From: Andi Kleen <andi@firstfloor.org>
Subject: Re: Some very basic questions
Date: Tue, 21 Oct 2008 18:59:26 +0200
Message-ID: <87iqrlevf5.fsf@basil.nowhere.org>
References: <20081021132322.271ad728.skraw@ithnet.com>
	<1224597580.27474.93.camel@think.oraclecorp.com>
	<20081021182710.a12f4914.skraw@ithnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Stephan von Krawczynski <skraw@ithnet.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081021182710.a12f4914.skraw@ithnet.com> (Stephan von Krawczynski's message of "Tue, 21 Oct 2008 18:27:10 +0200")
List-ID: <linux-btrfs.vger.kernel.org>

Stephan von Krawczynski <skraw@ithnet.com> writes:
>
> Yes, we hear and say that all the time, name one linux fs doing it, please.

ext[234] support it to some extent. It has some limitations
(especially when the files are large and you shouldn't do too much followon
IO to prevent the data from being overwriten) and the user frontends are not
very nice, but it it's there

-Andi

-- 
ak@linux.intel.com
