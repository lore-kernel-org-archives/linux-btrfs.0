From: Chris Mason <chris.mason@oracle.com>
Subject: Re: defrag makes fragmentation worse
Date: Wed, 12 Oct 2011 11:14:31 -0400
Message-ID: <1318432450-sup-2940@shiny>
References: <CAAE6i0gReLmmqvi3HXAAzjR6jgTScuqRwmdnUsEk0bY9yaCPHQ@mail.gmail.com> <4E93E000.1000700@cn.fujitsu.com> <CAAE6i0h6QZGmLoFUPgouHTeC0FYvHPgbODXHEthaL5p4mLruVQ@mail.gmail.com> <CAAE6i0j=7ZoYnXsmNdWewmszSpaq4HLcy+M7--3s2hiy2p4TBA@mail.gmail.com> <4E94FD75.6040307@cn.fujitsu.com> <CAAE6i0jdDn8i+yKEu5ytaGGkxbrg74PZU4LJRQjeTmBoFVKvpw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chester <somethingsome2000@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <CAAE6i0jdDn8i+yKEu5ytaGGkxbrg74PZU4LJRQjeTmBoFVKvpw@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Chester's message of 2011-10-12 00:14:21 -0400:
> On Tue, Oct 11, 2011 at 9:37 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> >
> >
> > This confirmed my speculation. I've fixed this bug a month ago, but
> > the patch hasn't hitted mainline.
> >
> > You can try it out:
> >
> > http://marc.info/?l=linux-btrfs&m=131495014823121&w=2
> >
> > With this bug fixed, I think autodefrag won't be problematic.
> >
> > --
> > Li Zefan
> 
> Yup. That patch fixes it for me. Thanks.

Thanks guys,

This patch is queued up now for the next release (3.2)

-chris
