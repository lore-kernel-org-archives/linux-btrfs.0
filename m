From: Wes Felter <wesley@felter.org>
Subject: Re: ssd optimised mode
Date: Mon, 23 Feb 2009 16:19:25 -0600
Message-ID: <gnv7dd$drd$1@ger.gmane.org>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>	 <20090220160134.GE24890@unused.rdu.redhat.com>	 <1235147425.13249.16.camel@think.oraclecorp.com> <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Dmitri Nikulin wrote:

> In the ideal future where SSDs can be run without a flimsy hardware
> FTL

I don't think this is likely at all for the same reasons Chris gave.

> I've read that one of the potentially crippling limitations of ZFS is
> that even its reliability features depend largely on being able to
> perform atomic writes, which are currently impossible (?) on flash
> media where a block has to be erased before it can be updated, clearly
> not an atomic operation. Is there any solution to this that doesn't
> depend on a battery backup?

A COW write to a pre-erased block should be atomic. See TxFlash: 
http://storagemojo.com/2009/01/17/transflash/

Wes Felter - wesley@felter.org

