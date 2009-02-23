From: Dongjun Shin <djshin90@gmail.com>
Subject: Re: ssd optimised mode
Date: Mon, 23 Feb 2009 12:15:51 +0900
Message-ID: <7fe698080902221915w6f961227ub26abae7f57302ae@mail.gmail.com>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>
	 <20090220160134.GE24890@unused.rdu.redhat.com>
	 <1235147425.13249.16.camel@think.oraclecorp.com>
	 <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
	 <49A18F01.3090300@austin.ibm.com>
	 <3a7f57190902221706l34e8f925m9ef687c1df920123@mail.gmail.com>
	 <7fe698080902221722q257819aaj4378dfc1509d3c7d@mail.gmail.com>
	 <3a7f57190902221833i61beb82u38c29dda0eaf5f42@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190902221833i61beb82u38c29dda0eaf5f42@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 23, 2009 at 11:33 AM, Dmitri Nikulin <dnikulin@gmail.com> wrote:
> On Mon, Feb 23, 2009 at 12:22 PM, Dongjun Shin <djshin90@gmail.com> wrote:
>> A well-designed SSD should survive power cycling and should provide atomicity
>> of flush operation regardless of the underlying flash operations. I don't expect
>> that users of SSD have different requirements about atomicity.
>
> Well that's my point, it "should" provide atomicity, but is this the
> case for consumer SSDs? It is certainly NOT the case for cheap
> USB-based flash media and AFAIK not for CF either.
>

AFAIK, all enterprise and consumer SSDs have atomicity requirements
because they're designed to replace the HDD without changes to the OS.

USB or any kind of flash-based cards have different requirements.
They're optimized for cost and the priority for the atomicity is low.
Moreover, they can be plugged out without prior notice to OS.

-- 
Dongjun
