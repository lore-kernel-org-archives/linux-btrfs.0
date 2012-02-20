From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: btrfs open_ctree failed (after recent Ubuntu update)
Date: Mon, 20 Feb 2012 13:23:00 +0700
Message-ID: <CAG1y0sdqOuRJ9RJhZ9MEkz8DYyGbsxPOzScAq70jBYE2YOR=tA@mail.gmail.com>
References: <455D7450-3946-478A-9021-6B01A4D7FB9B@gmail.com>
	<201202191000.34819.chris@csamuel.org>
	<FA65D86B-2BF3-49C9-941D-04AFF239523D@gmail.com>
	<201202192141.13497.chris@csamuel.org>
	<E271A902-2E12-494D-85D2-FFFD9362FC30@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org
To: Curtis Jones <curtis.jones@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <E271A902-2E12-494D-85D2-FFFD9362FC30@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 20, 2012 at 10:34 AM, Curtis Jones <curtis.jones@gmail.com>=
 wrote:
> Chris,
>
> Thank you for those kernel-update instructions. That was the least pa=
inful kernel update I could have imagined. I rebooted and verified (via=
 uname) that I am in fact running the new kernel. After looking at dmes=
g I can confirm that the exact same error is still occurring though. I =
re-read your previous email and saw that you recommended the 3.3-rc rel=
ease if 3.2.6 didn't suffice. So I did the same thing with 3.3-rc. And =
I found the same error (or what appears to be the same error), again:
>
>> [ =A0186.982910] device label StoreW devid 1 transid 37077 /dev/sdb
>> [ =A0187.015081] parent transid verify failed on 79466496 wanted 339=
99 found 36704
>> [ =A0187.015088] parent transid verify failed on 79466496 wanted 339=
99 found 36704
>> [ =A0187.015091] parent transid verify failed on 79466496 wanted 339=
99 found 36704
>> [ =A0187.015094] parent transid verify failed on 79466496 wanted 339=
99 found 36704
>> [ =A0187.015764] btrfs: open_ctree failed
>
> uname now reports:
>
>> Linux veriton 3.3.0-030300rc4-generic-pae #201202181935 SMP Sun Feb =
19 00:53:06 UTC 2012 i686 i686 i386 GNU/Linux
>
> I'm not sure what to try next;

I'd try with latest tools now. IIRC there's two programs you can try:
- btrfs-zero-log, which (as the name implies) zeroes-out transaction lo=
g
- restore, which would try to read files from a broken btrfs and copy
it elsewhere, and

Try the first one. If you can, dump the content of the disk to a file
first (with dd or dd_rescue) and try it on that file. Just in case
something goes horribly wrong :)

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
