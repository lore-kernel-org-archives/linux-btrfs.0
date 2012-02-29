From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Btrfs Storage Array Corrupted
Date: Wed, 29 Feb 2012 07:34:42 +0700
Message-ID: <CAG1y0sd5QHmrgawg5AFnFm6mj5AbE1LdLbD4Y0wXnuJR_EkrQQ@mail.gmail.com>
References: <CAPeorG-1EtMAu9XzSNqMW-=QwhN-_bZorLXy9Pr5N+J-LKPzTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Travis Shivers <ttshivers@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAPeorG-1EtMAu9XzSNqMW-=QwhN-_bZorLXy9Pr5N+J-LKPzTg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 29, 2012 at 7:13 AM, Travis Shivers <ttshivers@gmail.com> wrote:
> # ./btrfs-zero-log /dev/sdh
> parent transid verify failed on 5568194695168 wanted 43477 found 43151
> parent transid verify failed on 5568194695168 wanted 43477 found 43151
> parent transid verify failed on 5568194695168 wanted 43477 found 43151
> parent transid verify failed on 5568194695168 wanted 43477 found 43151
> Ignoring transid failure

Did you try a read-only mount (-o ro) after you run btrfs-zero-log?

-- 
Fajar
