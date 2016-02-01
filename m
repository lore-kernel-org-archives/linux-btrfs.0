Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:36745 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbcBADXW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 31 Jan 2016 22:23:22 -0500
Received: by mail-io0-f169.google.com with SMTP id g73so144574825ioe.3
        for <linux-btrfs@vger.kernel.org>; Sun, 31 Jan 2016 19:23:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKbQEqFYQ0XQAQOzOBX=n5jrxxws97Qd5OizEaGGq6tayEJcKg@mail.gmail.com>
References: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
	<CAPmG0jbLVVRJVoqehWxuNncF6oLydazo5-YO=3fLAbrksv2sJg@mail.gmail.com>
	<CAKbQEqH5twwezxYicthcCb6=dWgW3Hy-s6fLjH_BQETk4i0ikQ@mail.gmail.com>
	<CAJCQCtRw1VqaES4UCbaSNqCRXV5puA5gssxNSxsiUBKxa13dPQ@mail.gmail.com>
	<CAKbQEqFYQ0XQAQOzOBX=n5jrxxws97Qd5OizEaGGq6tayEJcKg@mail.gmail.com>
Date: Sun, 31 Jan 2016 20:23:21 -0700
Message-ID: <CAJCQCtQ3MMrOpJR9m4coD2a=DnGQ5KjP_RQ9n-jmLFOcFWPeAw@mail.gmail.com>
Subject: Re: "WARNING: device 0 not present" during scrub?
From: Chris Murphy <lists@colorremedies.com>
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 31, 2016 at 5:35 AM, Christian Pernegger
<pernegger@gmail.com> wrote:
> On 31 January 2016 at 02:42, Chris Murphy <lists@colorremedies.com> wrote:
>> On Sat, Jan 30, 2016 at 2:19 PM, Christian Pernegger
>> It maybe be stable for Debian but is Debian explicitly supporting
>> Btrfs with this release? I don't think they are.
>
> The modules are in the kernel, the progs are in the main archive, it's
> an option in the installer. It's not the default fs but I couldn't
> find any indication that it's more or less supported than, say, xfs.
> Why they've chosen 3.16 (and not 3.18, which would be a long term
> release) I don't know, but the fact remains that that's the default
> kernel of a tier 1 distro, so people using it are going to be around
> for a while.

The Debian wiki on Btrfs basically defers to upstream. And upstream
Btrfs recommends using newer kernels than this. Part of it is that
there have been literally thousands of changes, there are hundreds of
bugs discovered and fixed since that kernel version. Another part is
there so much change no one likely has any idea how to cross reference
the changes with your particular problem. So the request is to use
something newer because it's a practical compromise. Dollars to donuts
only a developer would know such details and yet surely such a detail
is lost among thousands of others because by now 3.16 is ancient
history.

At the very least, you should find a way to use btrfs-progs 4.4,
'btrfs check' (without --repair) against this volume, and report the
results. That's safe.

The easiest way I can think to do it is a Fedora nightly. I just
tested this one:
https://kojipkgs.fedoraproject.org/mash/rawhide-20160130/rawhide/x86_64/os/images/boot.iso

It has kernel 4.4rc1+ and btrfs-progs 4.4. You can boot from the
troubleshooting menu, rescue option, and choose option 3 "Skip to
shell" and then run btrfs check, again without --repair. This ISO
boots BIOS and UEFI systems, just dd it to a stick.

If that comes up clean you can even mount the volume and scrub it (the
scrub code is kernel code even though it's activated by user space
tools; whereas the fsck is in the user space tools).


-- 
Chris Murphy
