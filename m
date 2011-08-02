From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Slow snapshot deletion
Date: Mon, 01 Aug 2011 20:29:28 -0400
Message-ID: <1312244943-sup-9814@shiny>
References: <20110728200444.GA30801@untroubled.org> <1311884805-sup-7662@shiny> <20110801222604.GA3529@untroubled.org> <CAE5mzvgNYHkq6ETKkbs7GDryN4LmU8uw_wwTCDhKseubjxRfMQ@mail.gmail.com> <20110801225915.GA32470@untroubled.org>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Bruce Guenter <bruce@untroubled.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <20110801225915.GA32470@untroubled.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Bruce Guenter's message of 2011-08-01 18:59:15 -0400:
> On Mon, Aug 01, 2011 at 04:41:10PM -0600, cwillu wrote:
> > The keystroke should be alt-sysrq-w.
> 
> Right.  What I meant is that no backtraces are showing up.  I was
> actually using
> 
>     echo w > /proc/sysrq-trigger
> 
> and all I was seeing is:
> 
> SysRq : Show Blocked State
>   task                        PC stack   pid father
> 

# once per boot, run dmesg -n8
dmesg -n8

echo w > /proc/sysrq-trigger
