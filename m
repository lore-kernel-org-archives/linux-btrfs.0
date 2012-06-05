Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34453 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885Ab2FEVx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 17:53:27 -0400
Received: by dady13 with SMTP id y13so7859349dad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 14:53:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120605142826.d92316a0.akpm@linux-foundation.org>
References: <cover.1338889066.git.joe@perches.com> <20120605142826.d92316a0.akpm@linux-foundation.org>
From: Kay Sievers <kay@vrfy.org>
Date: Tue, 5 Jun 2012 23:53:02 +0200
Message-ID: <CAPXgP10J-3L3P-u9-6nGSHXj_+++Wq=5ysr72yPYrSA05QzoNg@mail.gmail.com>
Subject: Re: [PATCH 0/8] Rework KERN_<LEVEL>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 5, 2012 at 11:28 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue,  5 Jun 2012 02:46:29 -0700
> Joe Perches <joe@perches.com> wrote:
>
>> KERN_<LEVEL> currently takes up 3 bytes.
>> Shrink the kernel size by using an ASCII SOH and then the level byte.
>> Remove the need for KERN_CONT.
>> Convert directly embedded uses of <.> to KERN_<LEVEL>
>
> What an epic patchset.  I guess that saving a byte per printk does make
> the world a better place, and forcibly ensuring that nothing is
> dependent upon the internal format of the KERN_foo strings is nice.
>
>
> Unfortunately the <n> thing is part of the kernel ABI:
>
>        echo "<4>foo" > /dev/kmsg
>
> devkmsg_writev() does weird and wonderful things with
> facilities/levels.  That function incorrectly returns "success" when
> copy_from_user() faults, btw.  It also babbles on about LOG_USER and
> LOG_KERN without ever defining these things.  I guess they're
> userspace-only concepts and are hardwired to 0 and 1 in the kernel.  Or
> not.

It's as old as BSD, defined by syslog(3), used by glibc. The whole
<%u> prefix notation and the LOG_* names come from there.

The kernel is just user/facility == 0, so it never really was apparent
that the whole concept has more than a log level in that number.

Userspace syslog defines these pretty stupid numbers:
  /* facility codes */
  #define LOG_KERN        (0<<3)  /* kernel messages */
  #define LOG_USER        (1<<3)  /* random user-level messages */
  #define LOG_MAIL        (2<<3)  /* mail system */
  #define LOG_DAEMON      (3<<3)  /* system daemons */
  #define LOG_AUTH        (4<<3)  /* security/authorization messages */
  #define LOG_SYSLOG      (5<<3)  /* messages generated internally by syslogd */
  #define LOG_LPR         (6<<3)  /* line printer subsystem */
  #define LOG_NEWS        (7<<3)  /* network news subsystem */
  #define LOG_UUCP        (8<<3)  /* UUCP subsystem */
  #define LOG_CRON        (9<<3)  /* clock daemon */
  #define LOG_AUTHPRIV    (10<<3) /* security/authorization messages
(private) */
  #define LOG_FTP         (11<<3) /* ftp daemon */

but it *can* still all be pretty useful, and people *can* get creative
with facility numbers if they want to, as we have like 13 bits at the
moment to use for the facility which is stored in the kernel log
buffer. :)

/dev/kmsg just enforces LOG_USER, if userspace tries to inject stuff
with LOG_KERN, which it should not be allowed. The non-LOG_KERN number
itself has not much meaning it just says: "this is not from the
kernel" which is important to keep in the message.

Als, dmesg(1) has a -k option, that filters out all userspace-injected stuff.

> So what to do about /dev/kmsg?  I'd say "nothing": we retain "<n>" as
> the externally-presented kernel format for a facility level, and the
> fact that the kernel internally uses a different encoding is hidden
> from userspace.

Yeah, I think so.

Yeah, we strip the <>  at printk() time, add the <> back at output
time; they are not stored internally anymore, so that should not
affect the current behaviour.

> And if the user does
>
>        echo "\0014foo" > /dev/kmsg
>
> then I guess we should pass it straight through, retaining the \0014.
> But from my reading of your code, this doesn't work - vprintk_emit()
> will go ahead and strip and interpret the \0014, evading the stuff
> which devkmsg_writev() did.

We should make it not accept faked prefixes, yes. It should be
impossible to let messages look like they originated from the kernel,
just like the current code enforces a non-LOG_KERN <> prefix.

Kay
