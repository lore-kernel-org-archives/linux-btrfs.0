From: Chester <somethingsome2000@gmail.com>
Subject: Re: defrag makes fragmentation worse
Date: Tue, 11 Oct 2011 23:14:21 -0500
Message-ID: <CAAE6i0jdDn8i+yKEu5ytaGGkxbrg74PZU4LJRQjeTmBoFVKvpw@mail.gmail.com>
References: <CAAE6i0gReLmmqvi3HXAAzjR6jgTScuqRwmdnUsEk0bY9yaCPHQ@mail.gmail.com>
 <4E93E000.1000700@cn.fujitsu.com> <CAAE6i0h6QZGmLoFUPgouHTeC0FYvHPgbODXHEthaL5p4mLruVQ@mail.gmail.com>
 <CAAE6i0j=7ZoYnXsmNdWewmszSpaq4HLcy+M7--3s2hiy2p4TBA@mail.gmail.com> <4E94FD75.6040307@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E94FD75.6040307@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 11, 2011 at 9:37 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>
> This confirmed my speculation. I've fixed this bug a month ago, but
> the patch hasn't hitted mainline.
>
> You can try it out:
>
> http://marc.info/?l=linux-btrfs&m=131495014823121&w=2
>
> With this bug fixed, I think autodefrag won't be problematic.
>
> --
> Li Zefan

Yup. That patch fixes it for me. Thanks.
