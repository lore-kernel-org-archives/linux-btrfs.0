Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from b.mail.japannext.co.jp ([106.186.104.146]:40357 "EHLO
	b.mail.japannext.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbbHBFoH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 2 Aug 2015 01:44:07 -0400
Date: Sun, 2 Aug 2015 14:44:03 +0900
From: Georgi Georgiev <georgi-georgiev-btrfs@japannext.co.jp>
To: John Ettedgui <john.ettedgui@gmail.com>
Cc: =?utf-8?B?4oCcbGludXgtYnRyZnNAdmdlci5rZXJuZWwub3Jn4oCd?=
	<linux-btrfs@vger.kernel.org>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
Message-ID: <20150802054403.GB15867@jnext-0060.corp.japannext.co.jp>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
 <55BADEC4.3020409@cn.fujitsu.com>
 <CAJ3TwYS_C9LDU4ffsqtih3Rus6HREuA+gkb0kPpV_JNSyL4Bmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJ3TwYS_C9LDU4ffsqtih3Rus6HREuA+gkb0kPpV_JNSyL4Bmg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting John Ettedgui at 2015-07-30-21:10:27(-0700):
> On Thu, Jul 30, 2015 at 7:34 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> >
> > Hi John,
> > Thanks for the trace output.
> You are welcome, thank you for looking at it!
> >
> > But it seems that, your root partition is also btrfs, causing a lot of btrfs
> > trace from your systemd journal.
> >
> Oh yes sorry about that.
> I actually have 3 partition in btrfs, the problematic one being the
> only big one.
> > Would you mind re-collecting the ftrace without such logging system caused
> > btrfs trace?
> Sure, how would I do that?
> This is my first time using ftrace.
> >
> > BTW, although I'm not quite familiar with ftrace, would you please consider
> > collect ftrace with function_graph tracer?
> Sure, how would I do that one as well?

You can use set_ftrace_pid to trace only a single process (for example,
the mount command). There is a sample script I found in the ftrace
documentation that goes something like this:

# First disable tracing, to clear the trace buffer
echo nop            > current_tracer
echo 0              > tracing_on
echo 0              > tracing_enabled

# Then re-enable it after setting the filters
echo $$             > set_ftrace_pid
echo '*btrfs*'      > set_ftrace_filter
echo function_graph > current_tracer
echo 1              > tracing_enabled
echo 1              > tracing_on

# And finally *exec* the command to trace:
exec mount ....

I tried it, but the logs were way too large, and I was still fiddling
with the trace_options to set. If someone has good advice, we can try it
again

-- 
Georgi
