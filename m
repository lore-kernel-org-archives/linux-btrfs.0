From: Bruce Guenter <bruce@untroubled.org>
Subject: Re: Slow snapshot deletion
Date: Thu, 4 Aug 2011 10:35:36 -0600
Message-ID: <20110804163536.GA25185@untroubled.org>
References: <20110728200444.GA30801@untroubled.org>
 <1311884805-sup-7662@shiny>
 <1311886250-sup-5126@shiny>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5mCyUwZo2JvN/JJP"
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1311886250-sup-5126@shiny>
List-ID: <linux-btrfs.vger.kernel.org>


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 28, 2011 at 04:51:24PM -0400, Chris Mason wrote:
> Sorry, hit send too soon.  Here is the latencytop patch, after you
> recompile run latencytop -c for a few minutes.  Send the output here.
>=20
> http://oss.oracle.com/~mason/latencytop.patch

Ok, I ran it for more than a few minutes.  Early on (shortly after boot), t=
he output shows this for a long time:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Mon Aug  1 21:09:30 2011
Globals: Cause Maximum Percentage
Process details:
Process ksoftirqd/0 (3) Total:   3.9 msec
        [run_ksoftirqd]   3.9 msec        100.0 %
                run_ksoftirqd kthread kernel_thread_helper=20
Process kworker/1:1 (983) Total:  31.2 msec
        .         3.9 msec        100.0 %
                worker_thread kthread kernel_thread_helper=20
Process sshd (3948) Total:   3.9 msec
        Waiting for event (select)        3.9 msec        100.0 %
                poll_schedule_timeout do_select core_sys_select sys_select=
=20
                system_call_fastpath=20
Process btrfs-cleaner (4345) Total: 2433.6 msec
        [sleep_on_page]  31.3 msec        100.0 %
                sleep_on_page wait_on_page_bit read_extent_buffer_pages=20
                btree_read_extent_buffer_pages read_tree_block=20
                read_block_for_search btrfs_search_slot=20
                lookup_inline_extent_backref __btrfs_free_extent=20
                run_clustered_refs btrfs_run_delayed_refs __btrfs_end_trans=
action=20
Process btrfs-transacti (4346) Total: 2437.5 msec
        [sleep_on_page]  27.3 msec        100.0 %
                sleep_on_page wait_on_page_bit read_extent_buffer_pages=20
                btree_read_extent_buffer_pages read_tree_block=20
                read_block_for_search btrfs_search_slot=20
                lookup_inline_extent_backref __btrfs_free_extent=20
                run_clustered_refs btrfs_run_delayed_refs btrfs_commit_tran=
saction=20

This repeats identically (all numbers and backtrace is very stable) for
a long time.  Much later, I see this:

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Tue Aug  2 13:46:29 2011
Globals: Cause Maximum Percentage
Process details:
Process btrfs-submit-0 (4332) Total: 199.2 msec
        Creating block layer request     58.6 msec        100.0 %
                get_request_wait __make_request generic_make_request=20
                submit_bio run_scheduled_bios pending_bios_fn worker_loop=
=20
                kthread kernel_thread_helper=20
Process btrfs-cleaner (4345) Total:   3.9 msec
        Creating block layer request      3.9 msec        100.0 %
                get_request_wait __make_request generic_make_request=20
                submit_bio btrfs_map_bio btree_submit_bio_hook submit_one_b=
io=20
                read_extent_buffer_pages readahead_tree_block reada_walk_do=
wn=20
                do_walk_down walk_down_tree=20
Process btrfs-endio-met (4700) Total:  35.2 msec
        [worker_loop]     3.9 msec        100.0 %
                worker_loop kthread kernel_thread_helper=20
Process kworker/1:2 (26315) Total:  50.8 msec
        .         3.9 msec        100.0 %
                worker_thread kthread kernel_thread_helper=20
[...snip...]
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Thu Aug  4 12:34:08 2011
Globals: Cause Maximum Percentage
Process details:
Process btrfs-submit-0 (4332) Total: 199.2 msec
        Creating block layer request     58.6 msec        100.0 %
                get_request_wait __make_request generic_make_request=20
                submit_bio run_scheduled_bios pending_bios_fn worker_loop=
=20
                kthread kernel_thread_helper=20
Process btrfs-cleaner (4345) Total:   3.9 msec
        Creating block layer request      3.9 msec        100.0 %
                get_request_wait __make_request generic_make_request=20
                submit_bio btrfs_map_bio btree_submit_bio_hook submit_one_b=
io=20
                read_extent_buffer_pages readahead_tree_block reada_walk_do=
wn=20
                do_walk_down walk_down_tree=20
Process btrfs-endio-met (4700) Total:  35.2 msec
        [worker_loop]     3.9 msec        100.0 %
                worker_loop kthread kernel_thread_helper=20


--=20
Bruce Guenter <bruce@untroubled.org>                http://untroubled.org/

--5mCyUwZo2JvN/JJP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBAgAGBQJOOspYAAoJEFFRvcnBTTxnU98P/j2ozIYNb+wyVNT+YdEuron/
1jD8C9/ImKs3T5Gy1aqNRje2D1sUHUjq9ZaZWTTDWlNeH0xHsvyEA5nMRd/Ob6Ss
QQC1u4ky85HVxmSsLRmWg/ZQNOcxdLABNCvkdnOwVNGmB8CHr6s0cTQoXQHMWHKB
wXP8JlD5ctgPGIKTdVrpkyYQeBbLX+BIeXYxB2jmaa7K2dDXgc7i+YYgwtCgxrV3
ujnMia63+U36cMQMOgkkeKlG+G3HDzBHt8lAJ1RkfV1u5VYo/rbUazE54eoxSUaR
PzjSvLEOaAjShAJvDHQv3BcWtF0U07SQsA35FRxf5EfFOahq06wENfoVP1eKFTMB
scmE0U2hA7K0yoB907nBOeB0EQOR4d0A9e6M2mXUqrIwLWVSuz/DIUg1VL7iMELr
rmQrHnDie+Ukl7Ulwf4bM9P+DxrQj5e3WD3ckyg2GqW3YwsvTQ6k1TtcjTOrTLZN
OZ6syhZinAzThORfvJLoe96M5cFxIQH6fWh7svx99lx+rJOa5JvEbKHMHr6ZVVOq
DddGjVusuVFtEkpa7Abe+ODVgfA4ywpM1TU6oXJVfLOtIQ7+o2qO30mtoM7gu80R
ccqsE80gauGrKEBrOJlHKy723us/K2KEwfyi/R3EWaF6zf25uhYHMQy7P0TCsNqO
dNrA2JlwNcg70gQ/GTim
=YCMJ
-----END PGP SIGNATURE-----

--5mCyUwZo2JvN/JJP--
