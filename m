Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:35977 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932520Ab3HGLgP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Aug 2013 07:36:15 -0400
Received: by mail-la0-f53.google.com with SMTP id el20so194843lab.26
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Aug 2013 04:36:14 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130807104825.GO5284@twin.jikos.cz>
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
	<52015E8A.9000300@redhat.com>
	<CAL3q7H7e5r8bHrdR=kS2ueu8iM5q5fe6pkwm8W52fY-odMh6bw@mail.gmail.com>
	<5201652E.4000505@redhat.com>
	<20130807104825.GO5284@twin.jikos.cz>
Date: Wed, 7 Aug 2013 12:36:14 +0100
Message-ID: <CAL3q7H7W2GUci9+jjPEm-e+8SyCCFOwErwi67SdVFck3RtWx0A@mail.gmail.com>
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>, Eric Sandeen <sandeen@redhat.com>,
        Filipe Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 7, 2013 at 11:48 AM, David Sterba <dsterba@suse.cz> wrote:
> On Tue, Aug 06, 2013 at 04:05:50PM -0500, Eric Sandeen wrote:
>> I was thinking (and Josef just suggested too) that making a
>> dir flag, saying "everything under this dir gets compressed" might make
>> more sense for that scenario than adding a whole slew of
>> on-disk-persistent-mount-option code.
>
> We have this dir flag stored in the attributes, chattr +c dir/, but this
> cannot be tuned further - no way to specify the compression algorithm
> (or for example the target ratio as compression hint), or we can't say
> "never compress files in this dir (even if mounted with compression)"
> etc.

What Eric/Josef suggested, I think I've implemented it in the following RFC:

https://patchwork.kernel.org/patch/2840235/

The only thing it doesn't permit, is to disallow compression for
individual files or files placed under specific directories.
Any idea how would this be specified? (not via chattr I guess)


>
> david



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
