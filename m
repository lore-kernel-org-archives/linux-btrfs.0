Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:45109 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3LQPg6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 10:36:58 -0500
Received: by mail-bk0-f44.google.com with SMTP id d7so2872861bkh.17
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 07:36:56 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20131217152731.GR6498@twin.jikos.cz>
References: <1386963574-14467-1-git-send-email-fdmanana@gmail.com>
	<20131216143440.GE6498@twin.jikos.cz>
	<CAL3q7H5Eu8UQ-6zvsTB8omTMh-iMKAONYV7QEvRKbcMnyJ1U-g@mail.gmail.com>
	<20131217152731.GR6498@twin.jikos.cz>
Date: Tue, 17 Dec 2013 15:36:56 +0000
Message-ID: <CAL3q7H7DS9gee5kZhgeivVrcsU4p63EJdLa8q19jT8RfqbsWEQ@mail.gmail.com>
Subject: Re: [PATCH] Btrfs: fix use of uninitialized err variable
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 17, 2013 at 3:27 PM, David Sterba <dsterba@suse.cz> wrote:
> On Mon, Dec 16, 2013 at 05:03:25PM +0000, Filipe David Manana wrote:
>> On Mon, Dec 16, 2013 at 2:34 PM, David Sterba <dsterba@suse.cz> wrote:
>> > On Fri, Dec 13, 2013 at 07:39:34PM +0000, Filipe David Borba Manana wrote:
>> >> >From the compiler:
>> >>
>> >> fs/btrfs/file.c: In function ‘prepare_pages.isra.18’:
>> >> fs/btrfs/file.c:1265:6: warning: ‘err’ may be used uninitialized in this function [-Wuninitialized]
>> >
>> > My gcc 4.8.1 does not see this warning, nor do I while inspecting the
>> > souces in current next-master.
>>
>> Here it's gcc 4.6.3.
>
> I've seen that some versions of gcc produce bogus warnings of that sort
> and manual review is needed, but I haven't found a code path that would
> lead to uninitialized use of err.
>
> The warning points to
>
> 1259                 if (i == 0)
> 1260                         err = prepare_uptodate_page(pages[i], pos,
> 1261                                                     force_uptodate);
> 1262                 if (i == num_pages - 1)
> 1263                         err = prepare_uptodate_page(pages[i],
> 1264                                                     pos + write_bytes, false);
> 1265                 if (err) {
> ^^^^
>
> 1266                         page_cache_release(pages[i]);
> 1267                         faili = i - 1;
> 1268                         goto fail;
> 1269                 }
>
> But the loop starts from i = 0 and the variable is initialized before
> the check. So ti's gcc that does not see that, not a real error.

Right, my intention was to silence a compiler warning. Should have
made it more explicit in the commit message title.




-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
