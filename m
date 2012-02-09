From: cwillu <cwillu@cwillu.com>
Subject: Re: Freeing space over reboot question
Date: Thu, 9 Feb 2012 13:02:49 -0600
Message-ID: <CAE5mzvgQmCj4rrmfqvvNeyM-_-hOUpC_kEWrJQf5QwAzmLPGEQ@mail.gmail.com>
References: <20120209174232.318280@gmx.net>
	<20120210002055.6819f76c@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Norbert Scheibner <scno@gmx.net>, linux-btrfs@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120210002055.6819f76c@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 9, 2012 at 12:20 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Thu, 09 Feb 2012 18:42:32 +0100
> "Norbert Scheibner" <scno@gmx.net> wrote:
>
>> So the used space of subvolume I deleted, was not freed.
>
> AFAIK the only reliable way currently to ensure the space after a subvolume
> deletion is freed, is to remount the FS.
>
> In my opinion this is very inconvenient in many aspects, and I think "btrfs fi
> sync" absolutely should sync all ongoing cleanerd operations too. Which it
> currently doesn't, and in fact this makes me wonder, does "btrfs fi sync"
> even do anything more than the standard "sync" program at all.

It doesn't.  It triggers the same function that the global sync would
(but doesn't also sync every other mounted filesystem).
