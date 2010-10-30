From: Freddie Cash <fjwcash@gmail.com>
Subject: Re: Blog: "BTRFS is effectively stable"
Date: Sat, 30 Oct 2010 14:19:05 -0700
Message-ID: <AANLkTikRA_ZsXUJ6e_qYTuE0nzvV=YDrbqXs-Pjmqy0d@mail.gmail.com>
References: <201010301038.28038.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201010301038.28038.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 29, 2010 at 4:38 PM, Chris Samuel <chris@csamuel.org> wrote:
> A friend of mine who builds storage systems designed for HPC
> use has been keeping an eye on btrfs and has just done some
> testing of it with 2.6.36 and seems to like what he sees in
> terms of stability.

That's a *very* misleading conclusion to come to based solely on a
single file I/O test.  It's more realistic to say "stable under fio
load in ideal conditions".

For example:
  No device-yanking tests were done.
  No power-cord yanking tests were done.
  No device cables were yanked, shaken, or plugged/unplugged in rapid
succession.
  No "dd the raw device underneath the filesystem while doing file
I/O" tests were done.
  No recovery tests were done.

IOW, you can't really say "it's stable" across the board like that.

-- 
Freddie Cash
fjwcash@gmail.com
