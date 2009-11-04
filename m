From: David Nicol <davidnicol@gmail.com>
Subject: Re: Way to quickly "revert back" to a snapshot?
Date: Wed, 4 Nov 2009 15:57:26 -0600
Message-ID: <934f64a20911041357y57ee5854r83130ecac797b7ff@mail.gmail.com>
References: <4AD9FCDC.6060107@ubuntu.com> <20091026093842.GF5564@think>
	<4AEA8D20.3020504@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AEA8D20.3020504@jp.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 30, 2009 at 12:52 AM, TARUISI Hiroaki
<taruishi.hiroak@jp.fujitsu.com> wrote:
> I'm trying to make this snapshots/subvolumes listing feature,
> I wonder how the interface should be.
>
> Is there any other idea?

It's layers above where you're working, but how about providing a
virtual directory off the mounting root, like the lost+found
directories in other FSes, that would appear to contain them?
